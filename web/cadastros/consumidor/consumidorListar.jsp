<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
                        <th>Id</th>
                        <th>Nome</th>
                        <th>CPF</th>
                        <th>E-mail</th>
                        <th>Telefone</th>
                        <th> Formas de Pagamento</th>
                        <th>Endereços</th>
                        <th>Alterar</th>
                        <th>Excluir</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="consumidor" items="${lista}">
                        <tr>
                            <td align="right">${consumidor.id}</td>
                            <td><c:out value="${consumidor.nome}"/></td>
                            <td><c:out value="${consumidor.cpf}"/></td>
                            <td><c:out value="${consumidor.email}"/></td>
                            <td><c:out value="${consumidor.telefone}"/></td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${consumidor.dadosPagamento == 'PIX'}">PIX</c:when>
                                    <c:when test="${consumidor.dadosPagamento == 'CARTAO_CREDITO'}">Cartão de crédito</c:when>
                                    <c:when test="${consumidor.dadosPagamento == 'CARTAO_DEBITO'}">Cartão de débito</c:when>
                                    <c:when test="${consumidor.dadosPagamento == 'BOLETO'}">Boleto</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td align="center">
                                <a class="btn btn-sm btn-info"
                                   href="${pageContext.request.contextPath}/EnderecoListar?usuarioId=${consumidor.id}&amp;origem=ConsumidorListar">Endereços</a>
                            </td>
                            <td align="center">
                                <a class="btn btn-sm btn-primary"
                                   href="${pageContext.request.contextPath}/ConsumidorCarregar?id=${consumidor.id}">Alterar</a>
                            </td>
                            <td align="center">
                                <button type="button" class="btn btn-sm btn-danger"
                                        onclick="deletar(${consumidor.id})">Excluir</button>
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
            confirmButtonText: 'Sim, apague o consumidor!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (!result.isConfirmed) {
                return;
            }
            $.ajax({
                type: 'post',
                url: '${pageContext.request.contextPath}/ConsumidorExcluir',
                data: { id: id },
                success: function (data) {
                    var ok = (String(data).trim() === '1');
                    Swal.fire({
                        position: 'center',
                        icon: ok ? 'success' : 'error',
                        title: ok ? 'Sucesso' : 'Erro',
                        text: ok ? 'Consumidor excluído com sucesso!'
                                 : 'Não foi possível excluir o consumidor!',
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function () {
                        window.location.href = '${pageContext.request.contextPath}/ConsumidorListar';
                    });
                },
                error: function () {
                    window.location.href = '${pageContext.request.contextPath}/ConsumidorListar';
                }
            });
        });
    }
</script>
<jsp:include page="/footer.jsp"/>