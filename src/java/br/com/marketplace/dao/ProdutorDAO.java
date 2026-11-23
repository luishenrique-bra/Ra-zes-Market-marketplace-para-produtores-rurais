/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.dao;

import br.com.marketplace.model.Endereco;
import br.com.marketplace.model.Produtor;
import br.com.marketplace.utils.SingleConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProdutorDAO implements GenericDAO {
    
    private Connection conexao;
    
    public ProdutorDAO() throws Exception{
        conexao = SingleConnection.getConnection();
    }
    private static String nuloSeVazio(String s) {
        return (s == null || s.isBlank()) ? null : s;
    }
    private static String vazioSeNulo(String s) {
        return (s == null) ? "" : s.trim();
    }
    private void desfazer(String mensagem, Exception ex) {
        try {
            System.out.println(mensagem + " Erro: " + ex.getMessage());
            ex.printStackTrace();
            conexao.rollback();
        } catch (SQLException e) {
            System.out.println("Erro: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public Boolean cadastrar(Object objeto) {
        Produtor oProdutor = (Produtor) objeto;
        Boolean retorno=false;
        if (oProdutor.getId()== 0) {
            retorno = this.inserir(oProdutor);
        }else{
            retorno = this.alterar(oProdutor);
        }
        return retorno;
    }
    
    @Override
    public Boolean inserir(Object objeto) {
        Produtor oProdutor = (Produtor) objeto;
        String sqlUsuario = "insert into usuario (nome, cpf, email, telefone, senha) values (?,?,?,?,?) returning codigo";
        String sqlProdutor = "insert into produtor (codigo, cnpj, nomepropriedade) values (?,?,?)";
        try (PreparedStatement stmt = conexao.prepareStatement(sqlUsuario)) {
            stmt.setString(1, oProdutor.getNome());
            stmt.setString(2, nuloSeVazio(oProdutor.getCpf()));
            stmt.setString(3, oProdutor.getEmail());
            stmt.setString(4, oProdutor.getTelefone());
            stmt.setString(5, oProdutor.getSenha());
            int idGerado;
            try (ResultSet rs = stmt.executeQuery()) {
                rs.next();
                idGerado = rs.getInt(1);
            }
            try (PreparedStatement ps = conexao.prepareStatement(sqlProdutor)) {
                ps.setInt(1, idGerado);
                ps.setString(2, nuloSeVazio(oProdutor.getCnpj()));
                ps.setString(3, oProdutor.getNomePropriedade());
                ps.execute();
            }
            for (Endereco e : oProdutor.getEndereco()) {
                EnderecoDAO.inserirComConexao(conexao, e, idGerado);
            }
            conexao.commit();
            oProdutor.setId(idGerado);
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao cadastrar o Produtor! Erro: " + ex.getMessage());
                ex.printStackTrace();
                conexao.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        }
    }
    
    @Override
    public Boolean alterar(Object objeto) {
        Produtor oProdutor = (Produtor) objeto;
        boolean trocarSenha = oProdutor.getSenha() != null && !oProdutor.getSenha().isBlank();
        String sqlUsuario = trocarSenha
            ? "update usuario set nome=?, cpf=?, email=?, telefone=?, senha=? where codigo=?"
            : "update usuario set nome=?, cpf=?, email=?, telefone=? where codigo=?";
        String sqlProdutor = "update produtor set cnpj=?, nomepropriedade=? where codigo=?";
        try (PreparedStatement stmt = conexao.prepareStatement(sqlUsuario);
            PreparedStatement ps = conexao.prepareStatement(sqlProdutor)) {
            int i = 1;
            stmt.setString(i++, oProdutor.getNome());
            stmt.setString(i++, nuloSeVazio(oProdutor.getCpf()));
            stmt.setString(i++, oProdutor.getEmail());
            stmt.setString(i++, oProdutor.getTelefone());
            if (trocarSenha) stmt.setString(i++, oProdutor.getSenha());
            stmt.setInt(i, oProdutor.getId());
            stmt.execute();

            ps.setString(1, nuloSeVazio(oProdutor.getCnpj()));
            ps.setString(2, oProdutor.getNomePropriedade());
            ps.setInt(3, oProdutor.getId());
            ps.execute();

            conexao.commit();
            return true;
        } catch (Exception ex) {
            try {
                System.out.println("Problemas ao alterar o Produtor! Erro: " + ex.getMessage());
                ex.printStackTrace();
                conexao.rollback();
            } catch (SQLException e) {
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
                System.out.println("Problemas ao excluir o Produtor! Erro: "+ex.getMessage());
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
        String sql = "select u.codigo, u.nome, u.cpf, u.email, u.telefone, p.cnpj, p.nomepropriedade "
           + "from usuario u join produtor p on p.codigo = u.codigo where u.codigo=?";
        Produtor oProdutor = null;
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) 
        {
            stmt.setInt(1, numero);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                oProdutor = new Produtor();                
                oProdutor.setId(rs.getInt("codigo"));
                oProdutor.setNome(rs.getString("nome"));
                oProdutor.setCpf(rs.getString("cpf"));
                oProdutor.setEmail(rs.getString("email"));
                oProdutor.setTelefone(rs.getString("telefone"));
                oProdutor.setCnpj(rs.getString("cnpj"));
                oProdutor.setNomePropriedade(rs.getString("nomepropriedade"));
            }
            
            return oProdutor;
            
        } catch (SQLException ex) {
            System.out.println("Erro ao listar produtores: " + ex.getMessage());
            ex.printStackTrace();
            try { conexao.rollback(); } catch (SQLException ignored) {}
        }
        
        return oProdutor;
    }
    
    @Override
    public List<Object> listar() {
        List<Object> resultado = new ArrayList<>();
        String sql = "select u.codigo, u.nome, u.cpf, u.email, u.telefone, p.cnpj, p.nomepropriedade "
           + "from usuario u join produtor p on p.codigo = u.codigo order by u.codigo";

        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) 
        {

            while (rs.next()) {                
                Produtor oProdutor = new Produtor();
                oProdutor.setId(rs.getInt("codigo"));
                oProdutor.setNome(rs.getString("nome"));
                oProdutor.setCpf(rs.getString("cpf"));
                oProdutor.setEmail(rs.getString("email"));
                oProdutor.setTelefone(rs.getString("telefone"));
                oProdutor.setCnpj(rs.getString("cnpj"));
                oProdutor.setNomePropriedade(rs.getString("nomepropriedade"));
                resultado.add(oProdutor);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar produtores: " + ex.getMessage());
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
    
    public boolean cnpjExiste(String cnpj, int idIgnorar) {
        String sql = "select count(*) as quantidade_cnpj from produtor where cnpj = ? and codigo <> ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, cnpj);
            stmt.setInt(2, idIgnorar);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt("quantidade_cnpj") > 0;
            } catch (SQLException ex) {
                Logger.getLogger(ProdutorDAO.class.getName()).log(Level.SEVERE, null, ex);
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
