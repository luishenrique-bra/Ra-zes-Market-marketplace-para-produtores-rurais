<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Produtos</h1>
    <p class="mb-4">Cadastro de Produtos</p>

    <a class="btn btn-success mb-4" href="${pageContext.request.contextPath}/ProdutoNovo">
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
                        <th>Peso</th>
                        <th>Preço</th>
                        <th>Quantidade Estoque</th>
                        <th>Alterar</th>
                        <th>Excluir</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="produto" items="${lista}">
                        <tr>
                            <td align="right">${produto.id}</td>
                            <td><c:out value="${produto.nome}"/></td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${produto.peso > 0 && produto.peso < 1}">
                                        <fmt:formatNumber value="${produto.peso * 1000}" maxFractionDigits="0"/>g
                                    </c:when>
        
                                    <c:when test="${produto.peso >= 1}">
                                        <fmt:formatNumber value="${produto.peso}" maxFractionDigits="2"/>kg
                                    </c:when>
                                </c:choose>
                            </td>
                            <td><c:out value="${produto.preco}"/></td>
                            <td><c:out value="${produto.qtdeEstoque}"/></td>
                            <td align="center">
                                <a class="btn btn-sm btn-primary"
                                   href="${pageContext.request.contextPath}/ProdutoCarregar?id=${produto.id}">Alterar</a>
                            </td>
                            <td align="center">
                                <button type="button" class="btn btn-sm btn-danger"
                                        onclick="deletar(${produto.id})">Excluir</button>
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
            confirmButtonText: 'Sim, apague o produto!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (!result.isConfirmed) {
                return;
            }
            $.ajax({
                type: 'post',
                url: '${pageContext.request.contextPath}/ProdutoExcluir',
                data: { id: id },
                success: function (data) {
                    var ok = (String(data).trim() === '1');
                    Swal.fire({
                        position: 'center',
                        icon: ok ? 'success' : 'error',
                        title: ok ? 'Sucesso' : 'Erro',
                        text: ok ? 'Produto excluído com sucesso!'
                                 : 'Não foi possível excluir o produto!',
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function () {
                        window.location.href = '${pageContext.request.contextPath}/ProdutoListar';
                    });
                },
                error: function () {
                    window.location.href = '${pageContext.request.contextPath}/ProdutoListar';
                }
            });
        });
    }
</script>
<jsp:include page="/footer.jsp"/>