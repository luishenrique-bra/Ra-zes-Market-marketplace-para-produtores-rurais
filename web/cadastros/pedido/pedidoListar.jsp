<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
                        <th>Id</th>
                        <th>Data</th>
                        <th>Status</th>
                        <th>Motivo Cancelamento</th>
                        <th>Data Cancelamento</th>
                        <th class="text-center">Itens</th>
                        <th class="text-center">Alterar</th>
                        <th class="text-center">Excluir</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pedido" items="${lista}">
                        <tr>
                            <td align="right">${pedido.id}</td>
                            <td align="left">
                                <c:choose>
                                    <c:when test="${not empty pedido.dataPedido}">
                                        <fmt:formatDate value="${pedido.dataPedidoDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td align="left">${pedido.status}</td>
                            <td align="left">
                                <c:if test="${pedido.status == 'CANCELADO'}">
                                    <c:out value="${pedido.motivoCancelamento}"/>
                                </c:if>
                            </td>
                            <td align="left">
                                <c:if test="${pedido.status == 'CANCELADO' && not empty pedido.dataCancelamento}">
                                    <fmt:formatDate value="${pedido.dataCancelamentoDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:if>
                            </td>
                            <td align="center">
                                <a class="btn btn-sm btn-info"
                                    href="${pageContext.request.contextPath}/PedidoItensListar?pedidoId=${pedido.id}">
                                    <i class="fas fa-list"></i> Itens
                                </a>
                            </td>
                            <td align="center">
                                <a class="btn btn-sm btn-primary"
                                   href="${pageContext.request.contextPath}/PedidoCarregar?id=${pedido.id}">Alterar</a>
                            </td>
                            <td align="center">
                                <button type="button" class="btn btn-sm btn-danger"
                                        onclick="deletar(${pedido.id})">Excluir</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
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

    function deletar(id) {
        Swal.fire({
            title: 'Você tem certeza?',
            text: 'Você não poderá recuperar depois!',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sim, apague o pedido!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (!result.isConfirmed) {
                return;
            }
            $.ajax({
                type: 'post',
                url: '${pageContext.request.contextPath}/PedidoExcluir',
                data: { id: id },
                success: function (data) {
                    var ok = (String(data).trim() === '1');
                    Swal.fire({
                        position: 'center',
                        icon: ok ? 'success' : 'error',
                        title: ok ? 'Sucesso' : 'Erro',
                        text: ok ? 'Pedido excluído com sucesso!'
                                 : 'Não foi possível excluir o pedido!',
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function () {
                        window.location.href = '${pageContext.request.contextPath}/PedidoListar';
                    });
                },
                error: function () {
                    window.location.href = '${pageContext.request.contextPath}/PedidoListar';
                }
            });
        });
    }
</script>

<jsp:include page="/footer.jsp"/>