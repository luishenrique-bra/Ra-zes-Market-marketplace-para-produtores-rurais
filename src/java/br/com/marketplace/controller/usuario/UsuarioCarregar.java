/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.controller.usuario;

import br.com.marketplace.dao.GenericDAO;
import br.com.marketplace.dao.UsuarioDAO;
import br.com.marketplace.model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UsuarioCarregar", urlPatterns = {"/UsuarioCarregar"})
public class UsuarioCarregar extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=iso-8859-1");
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            GenericDAO usuarioDao = new UsuarioDAO();
            Usuario oUsuario = (Usuario) usuarioDao.carregar(id);
            request.setAttribute("usuario", oUsuario);
            request.getRequestDispatcher("/cadastros/usuario/usuarioCadastrar.jsp").forward(request, response);
        } catch(Exception ex){
            System.out.println("Problema no Servelet carregar Usuário! Erro: " + ex.getMessage());
            ex.printStackTrace();   
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
        return "Carrega o usuário";
    }
}
