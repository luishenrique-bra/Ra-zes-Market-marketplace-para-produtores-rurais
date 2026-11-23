/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.controller.usuario;

import br.com.marketplace.dao.UsuarioDAO;
import br.com.marketplace.model.Usuario;
import br.com.marketplace.utils.DocumentoValidador;
import br.com.marketplace.utils.EmailValidador;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UsuarioCadastrar", urlPatterns = {"/UsuarioCadastrar"})
public class UsuarioCadastrar extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=iso-8859-1");
        try {
            UsuarioDAO dao = new UsuarioDAO();
            
            String idStr = request.getParameter("id");
            int id = (idStr == null || idStr.isBlank()) ? 0 : Integer.parseInt(idStr.trim());
            String nome = request.getParameter("nome");
            String cpf = request.getParameter("cpf");
            cpf = (cpf == null) ? "" : cpf.replaceAll("\\D", "");
            String email = request.getParameter("email");
            email = (email == null) ? "" :email.trim().toLowerCase();
            String telefone = request.getParameter("telefone");
            String senha = request.getParameter("senha");
                if (senha == null) senha = "";
                
            if (!DocumentoValidador.isCPF(cpf)){
                response.getWriter().write("3");
            } else if (dao.cpfExiste(cpf, id)){
                response.getWriter().write("4");
            } else if (EmailValidador.isVazio(email)){
                response.getWriter().write("5");
            } else if (!EmailValidador.isEmail(email)){
                response.getWriter().write("6");
            } else if (dao.emailExiste(email, id)){
                response.getWriter().write("7");
            } else if (nome == null || nome.isBlank()) {
                response.getWriter().write("8");
            } else if (id == 0 && senha.isBlank()) {
                response.getWriter().write("9");
            } else {
                Usuario oUsuario = new Usuario();
                oUsuario.setId(id);
                oUsuario.setNome(nome);
                oUsuario.setCpf(cpf);
                oUsuario.setEmail(email);
                oUsuario.setTelefone(telefone);
                oUsuario.setSenha(senha);

                if (dao.cadastrar(oUsuario)){
                    response.getWriter().write("1");               
                } else {
                    response.getWriter().write("0");
                }
            }
        } catch (Exception ex){
            ex.printStackTrace();
            response.getWriter().write("0");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Cadastro e alteração de usuário";
    }
}
