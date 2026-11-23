/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.model;

public class Produtor extends Usuario{
    
    private String cnpj;
    private String nomePropriedade;
    
    public Produtor() {
        super();
        this.cnpj = "";
        this.nomePropriedade = "";
    }
    
    public Produtor(int id, String nome, String cpf, String email, String telefone, 
            String senha, String cnpj, String nomePropriedade) {
        super(id, nome, cpf, email, telefone, senha);
        this.cnpj = cnpj;
        this.nomePropriedade = nomePropriedade;
    }
    
    public String getCnpj() {
        return cnpj;
    }
    
    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }
    
    public String getNomePropriedade() {
        return nomePropriedade;
    }
    
    public void setNomePropriedade(String nomePropriedade) {
        this.nomePropriedade = nomePropriedade;
    }
}
