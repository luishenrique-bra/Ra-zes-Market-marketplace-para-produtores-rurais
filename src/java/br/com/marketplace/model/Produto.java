/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.model;

public class Produto {
    
    private int id;
    private String nome;
    private double preco;
    private double peso;
    private int qtdeEstoque;
    
    public Produto() {
        this.id = 0;
        this.nome = "";
        this.preco = 0;
        this.peso = 0;
        this.qtdeEstoque = 0;
    }
    
    public Produto(int id, String nome, double preco, double peso, int qtdeEstoque) {
        this.id = id;
        this.nome = nome;
        this.preco = preco;
        this.peso = peso;
        this.qtdeEstoque = qtdeEstoque;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getNome() {
        return nome;
    }
    
    public void setNome(String nome) {
        this.nome = nome;
    }
    
    public double getPreco() {
        return preco;
    }
    
    public void setPreco(double preco) {
        this.preco = preco;
    }
    
    public double getPeso() {
        return peso;
    }
    
    public void setPeso(double peso) {
        this.peso = peso;
    }
    
    public int getQtdeEstoque() {
        return qtdeEstoque;
    }
    
    public void setQtdeEstoque(int qtdeEstoque) {
        this.qtdeEstoque = qtdeEstoque;
    }
}
