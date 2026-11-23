/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.controller.endereco;

import br.com.marketplace.dao.EnderecoDAO;
import br.com.marketplace.model.Endereco;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EnderecoCadastrar", urlPatterns = {"/EnderecoCadastrar"})
public class EnderecoCadastrar extends HttpServlet {

    private static int lerInt(String s) {
        return (s == null || s.isBlank()) ? 0 : Integer.parseInt(s.trim());
    }
    private static String texto(String s) {
        return (s == null) ? "" : s.trim();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=iso-8859-1");
        try {
            EnderecoDAO dao = new EnderecoDAO();

            int id = lerInt(request.getParameter("id"));
            int usuarioId = lerInt(request.getParameter("usuarioId"));
            String cidade = texto(request.getParameter("cidade"));
            String estado = texto(request.getParameter("estado")).toUpperCase();
            String logradouro = texto(request.getParameter("logradouro"));
            int numero = lerInt(request.getParameter("numero"));
            String bairro = texto(request.getParameter("bairro"));
            String cep = texto(request.getParameter("cep")).replaceAll("\\D", "");
            String complemento = texto(request.getParameter("complemento"));

            if (usuarioId == 0) {
                response.getWriter().write("2");
            } else if (cidade.isEmpty()) {
                response.getWriter().write("3");
            } else if (estado.length() != 2) {
                response.getWriter().write("4");
            } else if (logradouro.isEmpty()) {
                response.getWriter().write("5");
            } else if (cep.length() != 8) {
                response.getWriter().write("6");
            } else {
                Endereco oEndereco = new Endereco();
                oEndereco.setId(id);
                oEndereco.setUsuarioId(usuarioId);
                oEndereco.setCidade(cidade);
                oEndereco.setEstado(estado);
                oEndereco.setLogradouro(logradouro);
                oEndereco.setNumero(numero);
                oEndereco.setBairro(bairro);
                oEndereco.setCep(cep);
                oEndereco.setComplemento(complemento);

                if (dao.cadastrar(oEndereco)) {
                    response.getWriter().write("1");
                } else {
                    response.getWriter().write("0");
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().write("0");
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
        return "Cadastro e alteração de Endereço";
    }// </editor-fold>

}
