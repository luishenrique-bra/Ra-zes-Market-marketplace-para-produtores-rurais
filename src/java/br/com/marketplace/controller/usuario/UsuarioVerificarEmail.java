/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.controller.usuario;

import br.com.marketplace.dao.UsuarioDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UsuarioVerificarEmail", urlPatterns = {"/UsuarioVerificarEmail"})
public class UsuarioVerificarEmail extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=iso-8859-1");
        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            String email = request.getParameter("email");
            email = (email == null) ? "" : email.trim().toLowerCase();
            String idStr = request.getParameter("id");
            int id = (idStr == null || idStr.isBlank()) ? 0 : Integer.parseInt(idStr.trim());
            response.setContentType("text/plain");
            if (usuarioDAO.emailExiste(email, id)){
                response.getWriter().write("1");
            } else {
                response.getWriter().write("0");
            }
            
        } catch (Exception ex){
            System.out.println("Problemas no Servlet ao validar email de usuario! Erro: " + ex.getMessage());
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
        return "Verifica e-mail duplicado";
    }

}
