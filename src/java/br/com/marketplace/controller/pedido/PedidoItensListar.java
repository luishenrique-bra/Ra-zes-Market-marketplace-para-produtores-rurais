package br.com.marketplace.controller.pedido;

import br.com.marketplace.dao.PedidoDAO;
import br.com.marketplace.model.ItemPedido;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PedidoItensListar", urlPatterns = {"/PedidoItensListar"})
public class PedidoItensListar extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=iso-8859-1");
        try {
            int pedidoId = Integer.parseInt(request.getParameter("pedidoId"));

            PedidoDAO dao = new PedidoDAO();
            List<ItemPedido> itens = dao.listarItens(pedidoId);

            BigDecimal total = BigDecimal.ZERO;

            request.setAttribute("pedidoId", pedidoId);
            request.setAttribute("itens", itens);
            request.setAttribute("total", total);
            request.getRequestDispatcher("/cadastros/pedido/pedidoItensListar.jsp")
                   .forward(request, response);
        } catch (Exception ex) {
            System.out.println("Problema no Servlet Listar Itens do Pedido! Erro: " + ex.getMessage());
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
        return "Lista pedido";
    }// </editor-fold>

}