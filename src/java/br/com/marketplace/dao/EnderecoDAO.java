/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.dao;

import br.com.marketplace.model.Endereco;
import br.com.marketplace.utils.SingleConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EnderecoDAO implements GenericDAO{
    
    private Connection conexao;
    
    public EnderecoDAO() throws Exception{
        conexao = SingleConnection.getConnection();
    }
    
    @Override
    public Boolean cadastrar(Object objeto) {
        Endereco oEndereco = (Endereco) objeto;
        Boolean retorno=false;
        if (oEndereco.getId()== 0) {
            retorno = this.inserir(oEndereco);
        }else{
            retorno = this.alterar(oEndereco);
        }
        return retorno;
    }
    
    @Override
    public Boolean inserir(Object objeto) {
        Endereco oEndereco = (Endereco) objeto;
        PreparedStatement stmt = null;
        String sql = "insert into endereco (usuarioid, cidade, estado, logradouro, numero, bairro, cep, complemento) "
                + "values (?,?,?,?,?,?,?,?)";  
        try {
            stmt = conexao.prepareStatement(sql);
            stmt.setInt(1, oEndereco.getUsuarioId());
            stmt.setString(2, oEndereco.getCidade());        
            stmt.setString(3, oEndereco.getEstado());
            stmt.setString(4, oEndereco.getLogradouro());
            stmt.setInt(5, oEndereco.getNumero());
            stmt.setString(6, oEndereco.getBairro());
            stmt.setString(7, oEndereco.getCep());
            stmt.setString(8, oEndereco.getComplemento());
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao cadastrar o Endereço! Erro: "+ex.getMessage());
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
        Endereco oEndereco = (Endereco) objeto;
        PreparedStatement stmt = null;
        String sql = "update endereco set cidade=?, estado=?, logradouro=?, numero=?, "
                + "bairro=?, cep=?, complemento=? where codigo=?";
        try {
            stmt = conexao.prepareStatement(sql);
            stmt.setString(1, oEndereco.getCidade());
            stmt.setString(2, oEndereco.getEstado());
            stmt.setString(3, oEndereco.getLogradouro());
            stmt.setInt(4, oEndereco.getNumero());
            stmt.setString(5, oEndereco.getBairro());
            stmt.setString(6, oEndereco.getCep());
            stmt.setString(7, oEndereco.getComplemento());
            int i = 8;
            stmt.setInt(i, oEndereco.getId());   
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao alterar o Endereco! Erro: "+ex.getMessage());
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
        String sql = "delete from endereco where codigo=?";  
        try {
            stmt = conexao.prepareStatement(sql);
            stmt.setInt(1, numero);
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao excluir o Endereco! Erro: "+ex.getMessage());
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
        String sql = "Select * from endereco where codigo=?";
        Endereco oEndereco = null;
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) 
        {
            stmt.setInt(1, numero);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                oEndereco = new Endereco();                
                oEndereco.setId(rs.getInt("codigo"));
                oEndereco.setUsuarioId(rs.getInt("usuarioId"));
                oEndereco.setCidade(rs.getString("cidade"));
                oEndereco.setEstado(rs.getString("estado"));
                oEndereco.setLogradouro(rs.getString("logradouro"));
                oEndereco.setNumero(rs.getInt("numero"));
                oEndereco.setBairro(rs.getString("bairro"));
                oEndereco.setCep(rs.getString("cep"));
                oEndereco.setComplemento(rs.getString("complemento"));
            }
            
            return oEndereco;
            
        } catch (SQLException ex) {
            System.out.println("Erro ao listar enderecos: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        
        return oEndereco;
    }
    
    @Override
    public List<Object> listar() {
        List<Object> resultado = new ArrayList<>();
        String sql = "Select * from endereco order by codigo";

        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) 
        {

            while (rs.next()) {                
                Endereco oEndereco = new Endereco();
                oEndereco.setId(rs.getInt("codigo"));
                oEndereco.setUsuarioId(rs.getInt("usuarioId"));
                oEndereco.setCidade(rs.getString("cidade"));
                oEndereco.setEstado(rs.getString("estado"));
                oEndereco.setLogradouro(rs.getString("logradouro"));
                oEndereco.setNumero(rs.getInt("numero"));
                oEndereco.setBairro(rs.getString("bairro"));
                oEndereco.setCep(rs.getString("cep"));
                oEndereco.setComplemento(rs.getString("complemento"));
                resultado.add(oEndereco);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar enderecos: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }  
        return resultado;
    }

    public List<Object> listarPorUsuario(int usuarioId) {
        List<Object> resultado = new ArrayList<>();
        String sql = "select * from endereco where usuarioid=? order by codigo";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, usuarioId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Endereco oEndereco = new Endereco();
                    oEndereco.setId(rs.getInt("codigo"));
                    oEndereco.setUsuarioId(rs.getInt("usuarioId"));
                    oEndereco.setCidade(rs.getString("cidade"));
                    oEndereco.setEstado(rs.getString("estado"));
                    oEndereco.setLogradouro(rs.getString("logradouro"));
                    oEndereco.setNumero(rs.getInt("numero"));
                    oEndereco.setBairro(rs.getString("bairro"));
                    oEndereco.setCep(rs.getString("cep"));
                    oEndereco.setComplemento(rs.getString("complemento"));
                    resultado.add(oEndereco);
                }
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar enderecos do usuário: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
            }
        return resultado;
    }
    
    static void inserirComConexao(Connection c, Endereco e, int usuarioId) throws SQLException {
        String sql = "insert into endereco (usuarioid, cidade, estado, logradouro, numero, bairro, cep, complemento) "
                + "values (?,?,?,?,?,?,?,?)";
        try (PreparedStatement stmt = c.prepareStatement(sql)) {
            stmt.setInt(1, usuarioId);
            stmt.setString(2, e.getCidade());
            stmt.setString(3, e.getEstado());
            stmt.setString(4, e.getLogradouro());
            stmt.setInt(5, e.getNumero());
            stmt.setString(6, e.getBairro());
            stmt.setString(7, e.getCep());
            stmt.setString(8, e.getComplemento());
            stmt.execute();
        }
    }
    
    static void alterarComConexao(Connection c, Endereco e, int usuarioId) throws SQLException {
        String sql = "update endereco set cidade=?, estado=?, logradouro=?, numero=?, "
                + "bairro=?, cep=?, complemento=? where codigo=? and usuarioId=?";
        try (PreparedStatement stmt = c.prepareStatement(sql)) {
            stmt.setString(1, e.getCidade());
            stmt.setString(2, e.getEstado());
            stmt.setString(3, e.getLogradouro());
            stmt.setInt(4, e.getNumero());
            stmt.setString(5, e.getBairro());
            stmt.setString(6, e.getCep());
            stmt.setString(7, e.getComplemento());
            stmt.setInt(8, e.getId());
            stmt.setInt(9, usuarioId);
            stmt.execute();
        }
    }
}
