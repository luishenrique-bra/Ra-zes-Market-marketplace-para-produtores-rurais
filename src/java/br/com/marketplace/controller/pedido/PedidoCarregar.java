package br.com.marketplace.controller.pedido;

import br.com.marketplace.dao.GenericDAO;
import br.com.marketplace.dao.PedidoDAO;
import br.com.marketplace.dao.ProdutoDAO;
import br.com.marketplace.model.Pedido;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PedidoCarregar", urlPatterns = {"/PedidoCarregar"})
public class PedidoCarregar extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            GenericDAO pedidoDao = new PedidoDAO();
            ProdutoDAO produtoDao = new ProdutoDAO();
            
            Pedido oPedido = (Pedido) pedidoDao.carregar(id);
            if (oPedido == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            request.setAttribute("pedido", oPedido);
            request.setAttribute("produtos", produtoDao.listar());
            
            request.getRequestDispatcher("/cadastros/pedido/pedidoCadastrar.jsp").forward(request, response);
        } catch(Exception ex){
            System.out.println("Problema no Servlet carregar Pedido! Erro: " + ex.getMessage());
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
        return "Carrega um Pedido";
    }// </editor-fold>

}