/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.model;

import java.math.BigDecimal;

public class ItemPedido {
    
    private int id;
    private int pedidoId;
    private int produtoId;
    private String produtoNome;
    private int quantidade;
    private BigDecimal precoUnitario;
    
    public ItemPedido() {
        this.id = 0;
        this.pedidoId = 0;
        this.produtoId = 0;
        this.produtoNome = "";
        this.quantidade = 0;
        this.precoUnitario = BigDecimal.ZERO;
    }
    
    public ItemPedido(int id, int pedidoId, int produtoId, int quantidade, double precoUnitario) {
        this.id = id;
        this.pedidoId = pedidoId;
        this.produtoId = produtoId;
        this.produtoNome = "";
        this.quantidade = quantidade;
        this.precoUnitario = BigDecimal.valueOf(precoUnitario);
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getPedidoId() {
        return pedidoId;
    }
    
    public void setPedidoId(int pedidoId) {
        this.pedidoId = pedidoId;
    }
    
    public int getProdutoId() {
        return produtoId;
    }
    
    public void setProdutoId(int produtoId) {
        this.produtoId = produtoId;
    }
    
    public String getProdutoNome() {
        return produtoNome;
    }
    
    public void setProdutoNome(String produtoNome) {
        this.produtoNome = produtoNome;
    }
    
    public int getQuantidade() {
        return quantidade;
    }
    
    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }
    
    public BigDecimal getPrecoUnitario() {
        return precoUnitario;
    }
    
    public void setPrecoUnitario(BigDecimal precoUnitario) {
        this.precoUnitario = precoUnitario;
    }
    
    public BigDecimal getSubtotal() {
        return precoUnitario.multiply(BigDecimal.valueOf(quantidade));
    }
}