/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.controller.produtor;

import br.com.marketplace.dao.ProdutorDAO;
import br.com.marketplace.model.Endereco;
import br.com.marketplace.model.Produtor;
import br.com.marketplace.utils.DocumentoValidador;
import br.com.marketplace.utils.EmailValidador;
import java.io.IOException;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ProdutorCadastrar", urlPatterns = {"/ProdutorCadastrar"})
public class ProdutorCadastrar extends HttpServlet {
    
    private static final Set<String> UFS = Set.of(
        "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA",
        "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO");
    private static String texto(String s) {
        return (s == null) ? "" : s.trim();
    }
    private static String digitos(String s) {
        return (s == null) ? "" : s.replaceAll("\\D", "");
    }
    private static int inteiro(String s) {
        String d = digitos(s);
        return (d.isEmpty() || d.length() > 9) ? 0 : Integer.parseInt(d);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=iso-8859-1");
        try {
            ProdutorDAO dao = new ProdutorDAO();
            
            int id = inteiro(request.getParameter("id"));
            String nome = texto(request.getParameter("nome"));
            String nomePropriedade = texto(request.getParameter("nomePropriedade"));
            String cpf = digitos(request.getParameter("cpf"));
            String cnpj = digitos(request.getParameter("cnpj"));
            String email = texto(request.getParameter("email")).toLowerCase();
            String telefone = texto(request.getParameter("telefone"));
            String senha = request.getParameter("senha");
            if (senha == null) senha = "";
            
            int enderecoId = inteiro(request.getParameter("enderecoId"));
            String cep = digitos(request.getParameter("cep"));
            String logradouro = texto(request.getParameter("logradouro"));
            String complemento = texto(request.getParameter("complemento"));
            String cidade = texto(request.getParameter("cidade"));
            String estado = texto(request.getParameter("estado")).toUpperCase();
                
            boolean enderecoPreenchido = !cep.isEmpty() || !logradouro.isEmpty()
                || !complemento.isEmpty() || !cidade.isEmpty() || !estado.isEmpty();
            boolean validaEndereco = (id == 0) || enderecoPreenchido;
        
            if (cpf.isEmpty() && cnpj.isEmpty()) {
                response.getWriter().write("13");
            } else if (!cpf.isEmpty() && !DocumentoValidador.isCPF(cpf)) {
                response.getWriter().write("3");
            } else if (!cpf.isEmpty() && dao.cpfExiste(cpf, id)) {
                response.getWriter().write("4");
            } else if (!cnpj.isEmpty() && !DocumentoValidador.isCNPJ(cnpj)) {
                response.getWriter().write("10");
            } else if (!cnpj.isEmpty() && dao.cnpjExiste(cnpj, id)) {
                response.getWriter().write("11");
            } else if (EmailValidador.isVazio(email)) {
                response.getWriter().write("5");
            }else if (!EmailValidador.isEmail(email)) {
                response.getWriter().write("6");
            } else if (dao.emailExiste(email, id)) {
                response.getWriter().write("7");
            } else if (nome.isBlank()) {
                response.getWriter().write("8");
            } else if (nomePropriedade.isBlank()) {
                response.getWriter().write("12");
            } else if (id == 0 && senha.isBlank()) {
                response.getWriter().write("9");
            } else if (validaEndereco && cep.length() != 8) {
                response.getWriter().write("14");
            } else if (validaEndereco && logradouro.isEmpty()) {
                response.getWriter().write("15");
            } else if (validaEndereco && cidade.isEmpty()) {
                response.getWriter().write("16");
            } else if (validaEndereco && !UFS.contains(estado)) {
                response.getWriter().write("17");
            } else {
                Produtor oProdutor = new Produtor();
                oProdutor.setId(id);
                oProdutor.setNome(nome);
                oProdutor.setNomePropriedade(nomePropriedade);
                oProdutor.setCpf(cpf);
                oProdutor.setCnpj(cnpj);
                oProdutor.setEmail(email);
                oProdutor.setTelefone(telefone);
                oProdutor.setSenha(senha);
                
                Endereco oEndereco = new Endereco();
                oEndereco.setId(enderecoId);
                oEndereco.setUsuarioId(id);
                oEndereco.setCep(cep);
                oEndereco.setLogradouro(logradouro);
                oEndereco.setNumero(0);
                oEndereco.setComplemento(complemento);
                oEndereco.setBairro("");
                oEndereco.setCidade(cidade);
                oEndereco.setEstado(estado);
                oProdutor.getEndereco().add(oEndereco);

                if (dao.cadastrar(oProdutor)){
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
        return "Cadastro e alteração de Produtor";
    }// </editor-fold>

}
