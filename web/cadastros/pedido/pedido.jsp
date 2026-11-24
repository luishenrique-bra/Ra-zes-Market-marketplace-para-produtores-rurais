<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page contentType="text/html" pageEncoding="iso-8859-1"%>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Pedidos</h1>
    <p class="mb-4">Cadastro de Pedidos</p>
    
    <a class="btn btn-success mb-4" href="${pageContext.request.contextPath}/PedidoNovo">
        <i class="fas fa-sticky-note"></i>
        <strong>Novo</strong>
    </a>
    
    <div class="card shadow">
        <div class="card-body">
            <table id="datatable" class="display">
                <thead>
                    <tr>
                        <th align="right">Id</th>
                        <th align="left">Data</th>
                        <th align="left">Status</th>
                        <th align="left">Motivo Cancelamento</th>
                        <th align="left">Data Cancelamento</th>
                        <th Align="center">Excluir</th>
                        <th Align="center">Alterar</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pedido" items="${lista}"> 
                        <tr>
                            <td align="right">${pedido.id}</td>
                            <td align="left">${pedido.dataPedido}</td>
                            <td align="left">${pedido.status}</td>
                            <td align="left">
                                <c:if test="${pedido.status == 'CANCELADO'}">
                                    <c:out value="${pedido.motivoCancelamento}"/>
                                </c:if>
                            </td>
                            <td align="left">
                                <c:if test="${pedido.status == 'CANCELADO'}">
                                    <fmt:formatDate value="${pedido.dataCancelamentoDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:if>
                            </td>
                            <td align="center">
                                <a href=${pageContext.request.contextPath}/PedidoListar?ConsumidorId=${pedido.id}">Pedidos</a>
                            </td>
                            <td align="center">
                                <a href="#" id="deletar" title="Excluir" onclick="deletar(${pedido.id})">
                                    <button>Excluir</button>
                                </a>
                            </td>                         
                            <td align="center">
                                <a href="${pageContext.request.contextPath}/PedidoCarregar?id=${pedido.id}">
                                   <button>Alterar</button>
                                </a>
                            </td>             
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>      
<script>
    $(document).ready(function() {
            console.log('entrei ready');
            $('#datatable').DataTable({
                "oLanguage": {
                    "sProcessing": "Processando...",
                    "sLengthMenu": "Mostrar _MENU_ registros",
                    "sZeroRecords": "Nenhum registro encontrado.",
                    "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
                    "sInfoEmpty": "Mostrando de 0 até 0 de 0 registros",
                    "sInfoFiltered": "",
                    "sInfoPostFix": "",
                    "sSearch": "Buscar:",
                    "sUrl": "",
                    "oPaginate": {
                        "sFirst": "Primeiro",
                        "sPrevious": "Anterior",
                        "sNext": "Seguinte",
                        "sLast": "Último"
                    }
                }
            });
        });
        
    function deletar(id){
        Swal.fire({
            title: 'Você tem certeza?',
            text: "Você não poderá recuperar depois!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sim, apague o pedido!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    type: 'post',
                    url: '${pageContext.request.contextPath}/PedidoExcluir',
                    data:{
                        id: id
                    },
                    success:
                        function(data){
                            if(data == 1){
                                Swal.fire({
                                    position: 'top-end',
                                    icon: 'success',
                                    title: 'Sucesso',
                                    text: 'Pedido excluído com sucesso!',
                                    showConfirmButton: false,
                                    timer: 2000
                                })
                            } else {
                                Swal.fire({
                                    position: 'top-end',
                                    icon: 'error',
                                    title: 'Erro',
                                    text: 'Não foi possível excluir o pedido!',
                                    showConfirmButton: false,
                                    timer: 2000
                                })
                            }
                            window.location.href = "${pageContext.request.contextPath}/PedidoListar";
                        },
                    error:
                        function(data){
                            window.location.href = "${pageContext.request.contextPath}/PedidoListar";
                        }
                });
            };
        });
    }
</script>
 <%@include file="/footer.jsp"%>