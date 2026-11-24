/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.dao;

import br.com.marketplace.model.Consumidor;
import br.com.marketplace.model.Endereco;
import br.com.marketplace.utils.SingleConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ConsumidorDAO implements GenericDAO {
    
    private Connection conexao;
    
    public ConsumidorDAO() throws Exception{
        conexao = SingleConnection.getConnection();
    }
    
    @Override
    public Boolean cadastrar(Object objeto) {
        Consumidor oConsumidor = (Consumidor) objeto;
        Boolean retorno=false;
        if (oConsumidor.getId()== 0) {
            retorno = this.inserir(oConsumidor);
        }else{
            retorno = this.alterar(oConsumidor);
        }
        return retorno;
    }
    
    @Override
    public Boolean inserir(Object objeto) {
        Consumidor oConsumidor = (Consumidor) objeto;
        PreparedStatement stmt = null;
        String sqlUsuario = "insert into usuario (nome, cpf, email, telefone, senha) values (?,?,?,?,?) returning codigo";
        String sqlConsumidor = "insert into consumidor (codigo, dadosPagamento) values (?,?)";
        try {
            stmt = conexao.prepareStatement(sqlUsuario);
            stmt.setString(1, oConsumidor.getNome());
            stmt.setString(2, oConsumidor.getCpf());
            stmt.setString(3, oConsumidor.getEmail());
            stmt.setString(4, oConsumidor.getTelefone());
            stmt.setString(5, oConsumidor.getSenha());
            int idGerado;
            try (ResultSet rs = stmt.executeQuery()) {
            rs.next();
            idGerado = rs.getInt(1);
            }
            try (PreparedStatement ps = conexao.prepareStatement(sqlConsumidor)) {
                ps.setInt(1, idGerado);
                ps.setString(2, oConsumidor.getDadosPagamento());        
                ps.execute();
            }
             for (Endereco e : oConsumidor.getEndereco()) {
                EnderecoDAO.inserirComConexao(conexao, e, idGerado);
            }
            conexao.commit();
            oConsumidor.setId(idGerado);
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao cadastrar o Consumidor! Erro: "+ex.getMessage());
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
        Consumidor oConsumidor = (Consumidor) objeto;
        PreparedStatement stmt = null;
        PreparedStatement ps = null;
        boolean trocarSenha = oConsumidor.getSenha() != null && !oConsumidor.getSenha().isBlank();
        String sqlUsuario = trocarSenha
        ? "update usuario set nome=?, cpf=?, email=?, telefone=?, senha=? where codigo=?"
        : "update usuario set nome=?, cpf=?, email=?, telefone=? where codigo=?";
        String sqlConsumidor = "update consumidor set dadosPagamento=? where codigo=?";
        try {
            stmt = conexao.prepareStatement(sqlUsuario);
            ps = conexao.prepareStatement(sqlConsumidor);
            int i = 1;
            stmt.setString(i++, oConsumidor.getNome());
            stmt.setString(i++, oConsumidor.getCpf());
            stmt.setString(i++, oConsumidor.getEmail());
            stmt.setString(i++, oConsumidor.getTelefone());
            if (trocarSenha) stmt.setString(i++, oConsumidor.getSenha());
            stmt.setInt(i, oConsumidor.getId());
            stmt.execute();
            
            ps.setString(1, oConsumidor.getDadosPagamento());
            ps.setInt(2, oConsumidor.getId());
            ps.execute();
            
            for (Endereco e : oConsumidor.getEndereco()) {
                if (e.getId() == 0) {
                    EnderecoDAO.inserirComConexao(conexao, e, oConsumidor.getId());
                } else {
                    EnderecoDAO.alterarComConexao(conexao, e, oConsumidor.getId());
                }
            }
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao alterar o Consumidor! Erro: "+ex.getMessage());
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
        PreparedStatement stmt = null;
        String sql = "delete from usuario where codigo=?";  
        try {
            stmt = conexao.prepareStatement(sql);
            stmt.setInt(1, numero);
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao excluir o Consumidor! Erro: "+ex.getMessage());
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
        String sql = "select u.codigo, u.nome, u.cpf, u.email, u.telefone, c.dadospagamento "
                + "from usuario u join consumidor c on c.codigo = u.codigo where u.codigo=?";
        Consumidor oConsumidor = null;
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) 
        {
            stmt.setInt(1, numero);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                oConsumidor = new Consumidor();                
                oConsumidor.setId(rs.getInt("codigo"));
                oConsumidor.setNome(rs.getString("nome"));
                oConsumidor.setCpf(rs.getString("cpf"));
                oConsumidor.setEmail(rs.getString("email"));
                oConsumidor.setTelefone(rs.getString("telefone"));
                oConsumidor.setDadosPagamento(rs.getString("dadosPagamento"));
            }
            
            return oConsumidor;
            
        } catch (SQLException ex) {
            System.out.println("Erro ao carregar consumidores: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        
        return oConsumidor;
    }
    
    @Override
    public List<Object> listar() {
        List<Object> resultado = new ArrayList<>();
        String sql = "select u.codigo, u.nome, u.cpf, u.email, u.telefone, c.dadospagamento "
                + "from usuario u join consumidor c on c.codigo = u.codigo order by u.codigo";

        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) 
        {

            while (rs.next()) {                
                Consumidor oConsumidor = new Consumidor();
                oConsumidor.setId(rs.getInt("codigo"));
                oConsumidor.setNome(rs.getString("nome"));
                oConsumidor.setCpf(rs.getString("cpf"));
                oConsumidor.setEmail(rs.getString("email"));
                oConsumidor.setTelefone(rs.getString("telefone"));
                oConsumidor.setDadosPagamento(rs.getString("dadosPagamento"));
                resultado.add(oConsumidor);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar consumidores: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        return resultado;
    }
        
    public boolean cpfExiste(String cpf, int idIgnorar) { 
        String sql = "select count(*) as quantidade_cpf from usuario where cpf = ? and codigo <> ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, cpf);
            stmt.setInt(2, idIgnorar);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt("quantidade_cpf") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try {conexao.rollback(); } catch (SQLException ignored) {}
        }
        return false;
    }
    
    public boolean emailExiste(String email, int idIgnorar) throws SQLException {
        String sql = "select count(*) as quantidade_email from usuario where lower(email) = lower(?) and codigo <> ? ";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setInt(2, idIgnorar);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt("quantidade_email") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try {conexao.rollback(); } catch (SQLException ignored) {}
        }
        return false;
    }
}
