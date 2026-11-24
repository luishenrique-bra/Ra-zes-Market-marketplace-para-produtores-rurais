package br.com.marketplace.dao;

import br.com.marketplace.model.ItemPedido;
import br.com.marketplace.model.Pedido;
import br.com.marketplace.utils.SingleConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

public class PedidoDAO implements GenericDAO {
    
    private Connection conexao;
    
    public PedidoDAO() throws Exception {
        conexao = SingleConnection.getConnection();
    }
    
    @Override
    public Boolean cadastrar(Object objeto) {
        Pedido oPedido = (Pedido) objeto;
        if (oPedido.getId() == 0) {
            return this.inserir(oPedido);
        } else {
            return this.alterar(oPedido);
        }
    }
    
    @Override
    public Boolean inserir(Object objeto) {
        Pedido oPedido = (Pedido) objeto;
        if (oPedido.getItens() == null || oPedido.getItens().isEmpty()) {
            return false;
        }
        
        String sqlPedido = "insert into pedido (consumidorid, datapedido, status) values (?,?,?) returning codigo";
        String sqlItem = "insert into itempedido (pedidoid, produtoid, quantidade, precounitario) values (?,?,?,?)";
        
        try (PreparedStatement stmt = conexao.prepareStatement(sqlPedido)) {
            LocalDateTime data = (oPedido.getDataPedido() == null) ? LocalDateTime.now() : oPedido.getDataPedido();
            stmt.setInt(1, oPedido.getConsumidorId());
            stmt.setTimestamp(2, Timestamp.valueOf(data));
            stmt.setString(3, oPedido.getStatus() != null ? oPedido.getStatus().name() : "CRIADO");
            
            int idGerado = 0;
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    idGerado = rs.getInt(1);
                }
            }
            
            if (idGerado == 0) {
                conexao.rollback();
                return false;
            }
            
            try (PreparedStatement ps = conexao.prepareStatement(sqlItem)) {
                for (ItemPedido oItem : oPedido.getItens()) {
                    ps.setInt(1, idGerado);
                    ps.setInt(2, oItem.getProdutoId());
                    ps.setInt(3, oItem.getQuantidade());
                    ps.setBigDecimal(4, oItem.getPrecoUnitario());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            
            conexao.commit();
            oPedido.setId(idGerado);
            return true;
        } catch (Exception ex) {
            System.out.println("Problemas ao cadastrar o Pedido! Erro: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
            return false;
        } 
    }
    
    @Override
    public Boolean alterar(Object objeto) {
        Pedido oPedido = (Pedido) objeto;
        if (oPedido.getItens() == null || oPedido.getItens().isEmpty()) {
            return false;
        }

        String sqlPedido = "update pedido set datapedido=datapedido where codigo=? and status <> 'CANCELADO'";
        String sqlApagaItens = "delete from itempedido where pedidoid=?";
        String sqlItem = "insert into itempedido (pedidoid, produtoid, quantidade, precounitario) values (?,?,?,?)";

        try {
            
            try (PreparedStatement stmt = conexao.prepareStatement(sqlPedido)) {
                stmt.setInt(1, oPedido.getId());
                if (stmt.executeUpdate() == 0) {
                    conexao.rollback();
                    return false;
                }
            }

            try (PreparedStatement stmt = conexao.prepareStatement(sqlApagaItens)) {
                stmt.setInt(1, oPedido.getId());
                stmt.executeUpdate();
            }

            try (PreparedStatement ps = conexao.prepareStatement(sqlItem)) {
                for (ItemPedido oItem : oPedido.getItens()) {
                    ps.setInt(1, oPedido.getId());
                    ps.setInt(2, oItem.getProdutoId());
                    ps.setInt(3, oItem.getQuantidade());
                    ps.setBigDecimal(4, oItem.getPrecoUnitario());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conexao.commit();
            return true;
        } catch (Exception ex) {
            System.out.println("Problemas ao alterar o Pedido! Erro: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
            return false;
        }
    }
    
    @Override
    public Boolean excluir(int numero) {
        String sql = "delete from pedido where codigo=?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, numero);
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            System.out.println("Erro ao excluir pedido: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
            return false;
        }
    }
    
    @Override
    public Object carregar(int numero) {
        String sqlPedido = "select codigo, consumidorid, datapedido, status, motivocancelamento, datacancelamento "
            + "from pedido where codigo=?";
        String sqlItens = "select codigo, pedidoid, produtoid, quantidade, precounitario "
            + "from itempedido where pedidoid=? order by codigo";
        Pedido oPedido = null;
        
        try (PreparedStatement stmt = conexao.prepareStatement(sqlPedido)) {
            stmt.setInt(1, numero);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    oPedido = montar(rs);
                }
            }
            
            if (oPedido != null) {
                try (PreparedStatement ps = conexao.prepareStatement(sqlItens)) {
                    ps.setInt(1, numero);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            ItemPedido oItem = new ItemPedido();
                            oItem.setId(rs.getInt("codigo"));
                            oItem.setPedidoId(rs.getInt("pedidoid"));
                            oItem.setProdutoId(rs.getInt("produtoid"));
                            oItem.setQuantidade(rs.getInt("quantidade"));
                            oItem.setPrecoUnitario(rs.getBigDecimal("precounitario"));
                            oPedido.getItens().add(oItem);
                        }
                    }
                }
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao carregar pedido: " + ex.getMessage());
            ex.printStackTrace();
        }
        return oPedido;
    }

    @Override
    public List<Object> listar() {
        List<Object> resultado = new ArrayList<>();
        String sql = "select codigo, consumidorid, datapedido, status, motivocancelamento, datacancelamento "
            + "from pedido order by codigo desc";

        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {                
                resultado.add(montar(rs));
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar pedidos: " + ex.getMessage());
            ex.printStackTrace();
        }
        return resultado;
    }
        
    private Pedido montar(ResultSet rs) throws SQLException {
        Pedido oPedido = new Pedido();
        oPedido.setId(rs.getInt("codigo"));
        oPedido.setConsumidorId(rs.getInt("consumidorid"));
        
        Timestamp tsData = rs.getTimestamp("datapedido");
        if (tsData != null) {
            oPedido.setDataPedido(tsData.toLocalDateTime());
        }
        
        String statusStr = rs.getString("status");
        if (statusStr != null && !statusStr.isBlank()) {
            oPedido.setStatus(statusStr);
        }
        
        oPedido.setMotivoCancelamento(rs.getString("motivocancelamento"));
        
        Timestamp tsCancel = rs.getTimestamp("datacancelamento");
        if (tsCancel != null) {
            oPedido.setDataCancelamento(tsCancel.toLocalDateTime());
        }
        return oPedido;
    }
    
    public List<ItemPedido> listarItens(int pedidoId) {
        List<ItemPedido> resultado = new ArrayList<>();
        String sql = "select i.codigo, i.produtoid, p.nome, i.quantidade, i.precounitario "
               + "from itempedido i join produto p on p.codigo = i.produtoid "
               + "where i.pedidoid = ? order by i.codigo";

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, pedidoId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ItemPedido oItem = new ItemPedido();
                    oItem.setId(rs.getInt("codigo"));
                    oItem.setProdutoId(rs.getInt("produtoid"));
                    oItem.setProdutoNome(rs.getString("nome"));
                    oItem.setQuantidade(rs.getInt("quantidade"));
                    oItem.setPrecoUnitario(rs.getBigDecimal("precounitario"));
                    resultado.add(oItem);
                }
            }   
        } catch (SQLException ex) {
            System.out.println("Erro ao listar itens do pedido: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        return resultado;
    }
}