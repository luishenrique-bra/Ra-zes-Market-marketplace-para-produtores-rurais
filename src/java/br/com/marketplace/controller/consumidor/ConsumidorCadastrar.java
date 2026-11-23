/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package br.com.marketplace.controller.consumidor;

import br.com.marketplace.dao.ConsumidorDAO;
import br.com.marketplace.model.Consumidor;
import br.com.marketplace.model.Endereco;
import br.com.marketplace.utils.DocumentoValidador;
import br.com.marketplace.utils.EmailValidador;
import java.io.IOException;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ConsumidorCadastrar", urlPatterns = {"/ConsumidorCadastrar"})
public class ConsumidorCadastrar extends HttpServlet {
    
    private static final Set<String> FORMAS_PAGAMENTO =
        Set.of("PIX", "CARTAO_CREDITO", "CARTAO_DEBITO", "BOLETO");
    private static final Set<String> UFS = Set.of(
            "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA",
            "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO");

    private static String texto(String s) {
        return (s == null) ? "" : s.trim();
    }

    private static int inteiro(String s) {
        String d = (s == null) ? "" : s.replaceAll("\\D", "");
        return (d.isEmpty() || d.length() > 9) ? 0 : Integer.parseInt(d);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=iso-8859-1");
        try {
            ConsumidorDAO dao = new ConsumidorDAO();
            
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
            String dadosPagamento = request.getParameter("dadosPagamento");
            dadosPagamento = (dadosPagamento == null) ? "" : dadosPagamento.trim();
            
            int enderecoId = inteiro(request.getParameter("enderecoId"));
            String cep = texto(request.getParameter("cep")).replaceAll("\\D", "");
            String logradouro = texto(request.getParameter("logradouro"));
            int numero = inteiro(request.getParameter("numero"));
            String complemento = texto(request.getParameter("complemento"));
            String bairro = texto(request.getParameter("bairro"));
            String cidade = texto(request.getParameter("cidade"));
            String estado = texto(request.getParameter("estado")).toUpperCase();
                
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
            } else if (!FORMAS_PAGAMENTO.contains(dadosPagamento)) {
                response.getWriter().write("10");
            } else if (cep.length() != 8) {
                response.getWriter().write("11");
            } else if (logradouro.isEmpty()) {
                response.getWriter().write("12");
            } else if (cidade.isEmpty()) {
                response.getWriter().write("13");
            } else if (!UFS.contains(estado)) {
                response.getWriter().write("14");
            } else {
                Consumidor oConsumidor = new Consumidor();
                oConsumidor.setId(id);
                oConsumidor.setNome(nome);
                oConsumidor.setCpf(cpf);
                oConsumidor.setEmail(email);
                oConsumidor.setTelefone(telefone);
                oConsumidor.setSenha(senha);
                oConsumidor.setDadosPagamento(dadosPagamento);
                
                Endereco oEndereco = new Endereco();
                oEndereco.setId(enderecoId);
                oEndereco.setUsuarioId(id);
                oEndereco.setCep(cep);
                oEndereco.setLogradouro(logradouro);
                oEndereco.setNumero(numero);
                oEndereco.setComplemento(complemento);
                oEndereco.setBairro(bairro);
                oEndereco.setCidade(cidade);
                oEndereco.setEstado(estado);
                oConsumidor.getEndereco().add(oEndereco);

                if (dao.cadastrar(oConsumidor)){
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
        return "Cadastro e alteração de Consumidor";
    }// </editor-fold>

}
