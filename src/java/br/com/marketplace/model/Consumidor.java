/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.model;

public class Consumidor extends Usuario{
    
    private String dadosPagamento;
    
    public Consumidor() {
        super();
        this.dadosPagamento = "";
    }
    
    public Consumidor(int id, String nome, String cpf, String email,
        String telefone, String senha, String dadosPagamento) {
        super(id, nome, cpf, email, telefone, senha);
        this.dadosPagamento = dadosPagamento;
    }

    public String getDadosPagamento() {
        return dadosPagamento;
    }
    
    public void setDadosPagamento(String dadosPagamento) {
        this.dadosPagamento = dadosPagamento;
    }
} 
