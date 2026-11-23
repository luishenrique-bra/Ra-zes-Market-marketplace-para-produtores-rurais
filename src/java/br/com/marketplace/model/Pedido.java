/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.marketplace.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Pedido {
    
    private int id;
    private int consumidorId;
    private Date dataPedido;
    private StatusPedido status = StatusPedido.CRIADO;
    private String motivoCancelamento;
    private Date dataCancelamento;
    private List<ItemPedido> itens = new ArrayList<>();
    
    // Cancela antes do envio
    public boolean isCancelavel() {
        return status == StatusPedido.CRIADO || status == StatusPedido.PAGO;
    }
    
    public void cancelar(String motivo) {
        if (!isCancelavel()) {
            throw new IllegalStateException("Este pedido não pode mais ser cancelado.");
        }
        this.status = StatusPedido.CANCELADO;
        this.motivoCancelamento = motivo;
        this.dataCancelamento = new Date();
    }
    
    public Pedido() {
        this.id = 0;
        this.consumidorId = 0;
        this.dataPedido = new Date();
        this.status = StatusPedido.CRIADO;
        this.motivoCancelamento = "";
        this.dataCancelamento = null;
        this.itens = new ArrayList<>();
    }
    
    public Pedido(int id, int consumidorId, Date dataPedido, StatusPedido status, String motivoCancelamento, 
            Date dataCancelamento) {
        this.id = id;
        this.consumidorId = consumidorId;
        this.dataPedido = dataPedido;
        this.status = status;
        this.motivoCancelamento = motivoCancelamento;
        this.dataCancelamento = dataCancelamento;
        this.itens = new ArrayList<>();
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getConsumidorId() {
        return consumidorId;
    }
    
    public void setConsumidorId(int consumidorId) {
        this.consumidorId = consumidorId;
    }
    
    public Date getDataPedido() {
        return dataPedido;
    }
    
    public void setDataPedido(Date dataPedido) {
        this.dataPedido = dataPedido;
    }
    
    public StatusPedido getStatus() {
        return status;
    }
    
    public void setStatus(StatusPedido status) {
        this.status = status;
    }
    
    public void setStatus(String status) {
        this.status = StatusPedido.valueOf(status.trim().toUpperCase());
    }
    
    public String getMotivoCancelamento() {
        return motivoCancelamento;
    }
    
    public void setMotivoCancelamento(String motivoCancelamento) {
        this.motivoCancelamento = motivoCancelamento;
    }
    
    public Date getDataCancelamento() {
        return dataCancelamento;
    }
    
    public void setDataCancelamento (Date dataCancelamento) {
        this.dataCancelamento = dataCancelamento;
    }
    
    public List<ItemPedido> getItens() {
        return itens;
    }
    
    public void setItens(List<ItemPedido> itens) {
        this.itens = itens;
    }
}
