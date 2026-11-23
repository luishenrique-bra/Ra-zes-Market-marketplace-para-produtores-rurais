/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.dao;

import br.com.marketplace.model.Produto;
import br.com.marketplace.utils.SingleConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProdutoDAO implements GenericDAO {
    
    private Connection conexao;
    
    public ProdutoDAO() throws Exception{
        conexao = SingleConnection.getConnection();
    }
    
    @Override
    public Boolean cadastrar(Object objeto) {
        Produto oProduto = (Produto) objeto;
        Boolean retorno=false;
        if (oProduto.getId()== 0) {
            retorno = this.inserir(oProduto);
        }else{
            retorno = this.alterar(oProduto);
        }
        return retorno;
    }

    @Override
    public Boolean inserir(Object objeto) {
        Produto oProduto = (Produto) objeto;
        String sql = "insert into produto (nome, preco, peso, qtdeestoque) "
                + "values (?,?,?,?)";  
        try (PreparedStatement stmt = conexao.prepareStatement(sql)){
            stmt.setString(1, oProduto.getNome());        
            stmt.setDouble(2, oProduto.getPreco());
            stmt.setDouble(3, oProduto.getPeso());
            stmt.setInt(4, oProduto.getQtdeEstoque());
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao cadastrar o Produto! Erro: "+ex.getMessage());
                ex.printStackTrace();
                conexao.rollback();
            } catch (SQLException e) {
                System.out.println("Erro:"+e.getMessage());
                e.printStackTrace();
            }
            return false;
        } 
    }

    @Override
    public Boolean alterar(Object objeto) {
        Produto oProduto = (Produto) objeto;
        String sql = "update produto set nome=?, preco=?, peso=?, qtdeestoque=? where codigo=?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)){
            int i = 1;
            stmt.setString(i++, oProduto.getNome());
            stmt.setDouble(i++, oProduto.getPreco());
            stmt.setDouble(i++, oProduto.getPeso());
            stmt.setInt(i++, oProduto.getQtdeEstoque());
            stmt.setInt(i, oProduto.getId());   
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao alterar o Produto! Erro: "+ex.getMessage());
                ex.printStackTrace();
                conexao.rollback();
            } catch (SQLException e) {
                System.out.println("Erro:"+e.getMessage());
                e.printStackTrace();
            }
            return false;
        } 
    }

    @Override
    public Boolean excluir(int numero) {
        String sql = "delete from produto where codigo=?";
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql)){
            stmt.setInt(1, numero);
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao excluir o Produto! Erro: "+ex.getMessage());
                ex.printStackTrace();
                conexao.rollback();
            } catch (SQLException e) {
                System.out.println("Erro:"+e.getMessage());
                e.printStackTrace();
            }
            return false;
        }  
    }

    @Override
    public Object carregar(int numero) {
        String sql = "Select * from produto where codigo=?";
        Produto oProduto = null;
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, numero);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                oProduto = new Produto();                
                oProduto.setId(rs.getInt("codigo"));
                oProduto.setNome(rs.getString("nome"));
                oProduto.setPreco(rs.getDouble("preco"));
                oProduto.setPeso(rs.getDouble("peso"));
                oProduto.setQtdeEstoque(rs.getInt("qtdeestoque"));
            }
            
            return oProduto;
            
        } catch (SQLException ex) {
            System.out.println("Erro ao listar produtos: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        
        return oProduto;
    }

    @Override
    public List<Object> listar() {
        List<Object> resultado = new ArrayList<>();
        String sql = "Select * from produto order by codigo";

        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) 
        {

            while (rs.next()) {                
                Produto oProduto = new Produto();
                oProduto.setId(rs.getInt("codigo"));
                oProduto.setNome(rs.getString("nome"));
                oProduto.setPreco(rs.getDouble("preco"));
                oProduto.setPeso(rs.getDouble("peso"));
                oProduto.setQtdeEstoque(rs.getInt("qtdeestoque"));
                resultado.add(oProduto);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar produtos: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        
        return resultado;
    }
    
    private void desfazer(String mensagem, Exception ex) {
        try {
            System.out.println(mensagem + " Erro: " + ex.getMessage());
            ex.printStackTrace();
            conexao.rollback();
        } catch (SQLException e) {
            System.out.println("Erro:" + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public boolean emUsoEmPedidos(int produtoId) {
        String sql = "select count(*) from itempedido where produtoid = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, produtoId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao verificar uso do produto em pedidos: " + ex.getMessage());
            try { conexao.rollback(); } catch (SQLException ignored) {}
            return false;
        }
    }
    
    public int calcularEstoqueTotal() {
        String sql = "select coalesce(sum(qtdeestoque), 0) as total from produto";

        try (PreparedStatement stmt = conexao.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException ex) {
            System.out.println("Erro ao calcular estoque: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        return 0;
    }
}
