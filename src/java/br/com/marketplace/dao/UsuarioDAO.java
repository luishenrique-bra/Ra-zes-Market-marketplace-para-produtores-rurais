/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.dao;

import br.com.marketplace.model.Usuario;
import br.com.marketplace.utils.SingleConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO implements GenericDAO {
    
    private Connection conexao;
    
    public UsuarioDAO() throws Exception{
        conexao = SingleConnection.getConnection();
    }
    
    @Override
    public Boolean cadastrar(Object objeto) {
        Usuario oUsuario = (Usuario) objeto;
        Boolean retorno=false;
        if (oUsuario.getId()== 0) {
            retorno = this.inserir(oUsuario);
        }else{
            retorno = this.alterar(oUsuario);
        }
        return retorno;
    }

    @Override
    public Boolean inserir(Object objeto) {
        Usuario oUsuario = (Usuario) objeto;
        PreparedStatement stmt = null;
        String sql = "insert into usuario (nome, cpf, email, telefone, senha) "
                + "values (?,?,?,?,?)";  
        try {
            stmt = conexao.prepareStatement(sql);
            stmt.setString(1, oUsuario.getNome());        
            stmt.setString(2, oUsuario.getCpf());
            stmt.setString(3, oUsuario.getEmail());
            stmt.setString(4, oUsuario.getTelefone());
            stmt.setString(5, oUsuario.getSenha());
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao cadastrar a Usuário! Erro: "+ex.getMessage());
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
        Usuario oUsuario = (Usuario) objeto;
        PreparedStatement stmt = null;
        boolean trocarSenha = oUsuario.getSenha() != null && !oUsuario.getSenha().isBlank();
        String sql = trocarSenha 
            ? "update usuario set nome=?, cpf=?, email=?, telefone=?, senha=? where codigo=?"
            : "update usuario set nome=?, cpf=?, email=?, telefone=? where codigo=?";
        try {
            int i = 1;
            stmt = conexao.prepareStatement(sql);
            stmt.setString(i++, oUsuario.getNome());
            stmt.setString(i++, oUsuario.getCpf());
            stmt.setString(i++, oUsuario.getEmail());
            stmt.setString(i++, oUsuario.getTelefone());
            if (trocarSenha) stmt.setString(i++, oUsuario.getSenha());
            stmt.setInt(i, oUsuario.getId());   
            stmt.execute();
            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao alterar a Usuário! Erro: "+ex.getMessage());
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
                System.out.println("Problemas ao excluir o Usuário! Erro: "+ex.getMessage());
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
        String sql = "Select * from usuario where codigo=?";
        Usuario oUsuario = null;
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) 
        {
            stmt.setInt(1, numero);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                oUsuario = new Usuario();                
                oUsuario.setId(rs.getInt("codigo"));
                oUsuario.setNome(rs.getString("nome"));
                oUsuario.setCpf(rs.getString("cpf"));
                oUsuario.setEmail(rs.getString("email"));
                oUsuario.setTelefone(rs.getString("telefone"));
                oUsuario.setSenha(rs.getString("senha"));
            }
            
            return oUsuario;
            
        } catch (SQLException ex) {
            System.out.println("Erro ao listar usuários: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        
        return oUsuario;
    }

    @Override
    public List<Object> listar() {
        List<Object> resultado = new ArrayList<>();
        String sql = "Select * from usuario order by codigo";

        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) 
        {

            while (rs.next()) {                
                Usuario oUsuario = new Usuario();
                oUsuario.setId(rs.getInt("codigo"));
                oUsuario.setNome(rs.getString("nome"));
                oUsuario.setCpf(rs.getString("cpf"));
                oUsuario.setEmail(rs.getString("email"));
                oUsuario.setTelefone(rs.getString("telefone"));
                oUsuario.setSenha(rs.getString("senha"));
                resultado.add(oUsuario);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar usuários: " + ex.getMessage());
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
        String sql = "select count(*) as quantidade_email from usuario where lower(email) = lower(?) AND codigo <> ? ";
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
