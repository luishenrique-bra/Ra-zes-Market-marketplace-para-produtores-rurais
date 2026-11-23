/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.controller.produto;

import br.com.marketplace.dao.ProdutoDAO;
import br.com.marketplace.model.Produto;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ProdutoCadastrar", urlPatterns = {"/ProdutoCadastrar"})
public class ProdutoCadastrar extends HttpServlet {
    
    private static String texto(String s) {
        return (s == null) ? "" : s.trim();
    }
    private static int lerId(String s) {
        String d = (s == null) ? "" : s.replaceAll("\\D", "");
        return (d.isEmpty() || d.length() > 9) ? 0 : Integer.parseInt(d);
    }
    private static double lerPreco(String s) {
        String t = s.trim();
        if (t.contains(",")) {
            t = t.replace(".", "").replace(",", ".");
        }
        return Double.parseDouble(t);
    }
    private static double lerPeso(String s) {
        if (s == null) return 0.0;
        String t = s.trim().toLowerCase();
        double multiplicador = 1.0;
        if (t.endsWith("g") && !t.endsWith("kg")) {
            multiplicador = 0.001;
        }        
        t = t.replaceAll("[a-zA-Z]", "").trim();
        if (t.contains(",")) {
            t = t.replace(".", "").replace(",", ".");
        }
        return Double.parseDouble(t) * multiplicador;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=iso-8859-1");
        try {
            int id = lerId(request.getParameter("id"));
            String nome = texto(request.getParameter("nome"));
            String precoTexto = texto(request.getParameter("preco"));
            String pesoTexto = texto(request.getParameter("peso"));
            String estoqueTexto = texto(request.getParameter("qtdeEstoque"));

            if (nome.isEmpty() || precoTexto.isEmpty() || pesoTexto.isEmpty() || estoqueTexto.isEmpty()) {
                response.getWriter().write("3");
                return;
            }

            double preco = lerPreco(precoTexto);
            double peso = lerPeso(pesoTexto);
            int qtdeEstoque = Integer.parseInt(estoqueTexto);

            if (!Double.isFinite(preco) || !Double.isFinite(peso)
                    || preco < 0 || peso < 0 || qtdeEstoque < 0) {
                response.getWriter().write("4");
                return;
            }

            Produto oProduto = new Produto();
            oProduto.setId(id);
            oProduto.setNome(nome);
            oProduto.setPreco(preco);
            oProduto.setPeso(peso);
            oProduto.setQtdeEstoque(qtdeEstoque);

            ProdutoDAO dao = new ProdutoDAO();

            if (dao.cadastrar(oProduto)) {
                response.getWriter().write("1");
            } else {
                response.getWriter().write("0");
            }

        } catch (NumberFormatException ex) {
            response.getWriter().write("4");

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
        return "Cadastro e alteração de Produto";
    }// </editor-fold>

}
