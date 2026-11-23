/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.controller.endereco;

import br.com.marketplace.dao.EnderecoDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EnderecoListar", urlPatterns = {"/EnderecoListar"})
public class EnderecoListar extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=iso-8859-1");
        try {
            String usuarioIdStr = request.getParameter("usuarioId");
            int usuarioId = (usuarioIdStr == null || usuarioIdStr.isBlank()) ? 0 : Integer.parseInt(usuarioIdStr.trim());
            EnderecoDAO dao = new EnderecoDAO();
            request.setAttribute("lista", dao.listarPorUsuario(usuarioId));
            request.setAttribute("usuarioId", usuarioId);
            request.getRequestDispatcher("/cadastros/endereco/enderecoListar.jsp").forward(request, response);
        } catch (Exception ex) {
            System.out.println("Problema no Servlet Listar Endereço! Erro:" + ex.getMessage());
            ex.printStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Lista Endereço";
    }// </editor-fold>

}
