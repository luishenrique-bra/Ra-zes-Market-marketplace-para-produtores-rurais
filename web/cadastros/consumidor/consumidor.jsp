<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page contentType="text/html" pageEncoding="iso-8859-1"%>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Consumidores</h1>
    <p class="mb-4">Cadastro de Consumidores</p>
    
    <a class="btn btn-success mb-4" href="${pageContext.request.contextPath}/ConsumidorNovo">
        <i class="fas fa-sticky-note"></i>
        <strong>Novo</strong>
    </a>
    
    <div class="card shadow">
        <div class="card-body">
            <table id="datatable" class="display">
                <thead>
                    <tr>
                        <th align="right">Id</th>
                        <th align="left">Nome</th>
                        <th align="left">CPF</th>
                        <th align="right">Email</th>
                        <th align="left">Telefone</th>
                        <th align="center">Endereco</th>
                        <th Align="center">Excluir</th>
                        <th Align="center">Alterar</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="consumidor" items="${lista}"> 
                        <tr>
                            <td align="right">${consumidor.id}</td>
                            <td align="left">${consumidor.nome}</td>
                            <td align="left">${consumidor.cpf}</td>
                            <td align="left">${consumidor.email}</td>
                            <td align="left">${consumidor.telefone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${consumidor.dadosPagamento == 'PIX'}">PIX</c:when>
                                    <c:when test="${consumidor.dadosPagamento == 'CARTAO_CREDITO'}">Cartão de crédito</c:when>
                                    <c:when test="${consumidor.dadosPagamento == 'CARTAO_DEBITO'}">Cartão de débito</c:when>
                                    <c:when test="${consumidor.dadosPagamento == 'BOLETO'}">Boleto</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td align="center">
                                <a href=${pageContext.request.contextPath}/EnderecoListar?usuarioId=${consumidor.id}">Endereços</a>
                            </td>
                            <td align="center">
                                <a href="#" id="deletar" title="Excluir" onclick="deletar(${usuario.id})">
                                    <button>Excluir</button>
                                </a>
                            </td>                         
                            <td align="center">
                                <a href="${pageContext.request.contextPath}/ConsumidorCarregar?id=${consumidor.id}">
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
            confirmButtonText: 'Sim, apague o consumidor!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    type: 'post',
                    url: '${pageContext.request.contextPath}/ConsumidorExcluir',
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
                                    text: 'Consumidor excluído com sucesso!',
                                    showConfirmButton: false,
                                    timer: 2000
                                })
                            } else {
                                Swal.fire({
                                    position: 'top-end',
                                    icon: 'error',
                                    title: 'Erro',
                                    text: 'Não foi possível excluir o consumidor!',
                                    showConfirmButton: false,
                                    timer: 2000
                                })
                            }
                            window.location.href = "${pageContext.request.contextPath}/ConsumidorListar";
                        },
                    error:
                        function(data){
                            window.location.href = "${pageContext.request.contextPath}/ConsumidorListar";
                        }
                });
            };
        });
    }
</script>
 <%@include file="/footer.jsp"%>