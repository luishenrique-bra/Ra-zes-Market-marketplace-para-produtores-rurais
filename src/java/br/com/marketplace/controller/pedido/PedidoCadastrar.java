package br.com.marketplace.controller.pedido;

import br.com.marketplace.dao.PedidoDAO;
import br.com.marketplace.dao.ProdutoDAO;
import br.com.marketplace.model.ItemPedido;
import br.com.marketplace.model.Pedido;
import br.com.marketplace.model.Produto;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PedidoCadastrar", urlPatterns = {"/PedidoCadastrar"})
public class PedidoCadastrar extends HttpServlet {
    
    private static int lerInt(String s) {
        return (s == null || s.isBlank()) ? 0 : Integer.parseInt(s.trim());
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=iso-8859-1");
        
        try {
            PedidoDAO dao = new PedidoDAO();
            ProdutoDAO produtoDao = new ProdutoDAO();
            
            // Trata o Consumidor da Sessão (se nulo, usa ID 1 como fallback para testes)
            Integer consumidorId = (Integer) request.getSession().getAttribute("usuarioId");
            if (consumidorId == null || consumidorId == 0) {
                consumidorId = 1;
            }

            String[] produtos = request.getParameterValues("produtoId");
            String[] quantidades = request.getParameterValues("quantidade");

            if (produtos == null || quantidades == null || produtos.length == 0 || produtos.length != quantidades.length) {
                response.getWriter().write("3");
                return;
            }
            
            Pedido oPedido = new Pedido();
            oPedido.setId(lerInt(request.getParameter("id")));
            oPedido.setConsumidorId(consumidorId);

            // Preenchimento dos itens do pedido com consulta ao preço unitário
            for (int i = 0; i < produtos.length; i++) {
                int produtoId = lerInt(produtos[i]);
                int quantidade = lerInt(quantidades[i]);
                if (produtoId <= 0 || quantidade <= 0) {
                    response.getWriter().write("4");
                    return;
                }
                
                ItemPedido oItem = new ItemPedido();
                oItem.setProdutoId(produtoId);
                oItem.setQuantidade(quantidade);
                
                // Busca o preço unitário cadastrado do produto
                Produto p = (Produto) produtoDao.carregar(produtoId);
                if (p != null) {
                    oItem.setPrecoUnitario(BigDecimal.valueOf(p.getPreco()));
                } else {
                    oItem.setPrecoUnitario(BigDecimal.ZERO);
                }

                oPedido.getItens().add(oItem);
            }
            
            // Executa a gravação
            if (dao.cadastrar(oPedido)) {
                response.getWriter().write("1");
            } else if (dao.isErroEstoque()) {
                response.getWriter().write("5;" + dao.getErroProdutoId() + ";" + dao.getErroDisponivel());
            } else {
                response.getWriter().write("0");
            }
        } catch (Exception ex) {
            System.out.println("Erro na Servlet PedidoCadastrar: " + ex.getMessage());
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
        return "Cadastra um Pedido";
    }// </editor-fold>

}