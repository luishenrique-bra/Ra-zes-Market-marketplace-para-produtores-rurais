<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- de onde a pessoa veio (só aceita estes dois valores) --%>
<c:set var="origem" value="${param.origem == 'ProdutorListar' ? 'ProdutorListar' : 'ConsumidorListar'}"/>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Endereços</h1>
    <p class="mb-4">Endereços cadastrados</p>

    <a class="btn btn-secondary mb-4" href="${pageContext.request.contextPath}/${origem}">
        <i class="fas fa-undo-alt"></i>
        <strong>Voltar</strong>
    </a>
    <a class="btn btn-success mb-4"
       href="${pageContext.request.contextPath}/EnderecoNovo?usuarioId=${usuarioId}&amp;origem=${origem}">
        <i class="fas fa-sticky-note"></i>
        <strong>Novo endereço</strong>
    </a>

    <div class="card shadow">
        <div class="card-body">
            <table id="datatable" class="display">
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Logradouro</th>
                        <th>Número</th>
                        <th>Bairro</th>
                        <th>Cidade/UF</th>
                        <th>CEP</th>
                        <th>Alterar</th>
                        <th>Excluir</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="endereco" items="${lista}">
                        <tr>
                            <td align="right">${endereco.id}</td>
                            <td align="center"><c:out value="${endereco.logradouro}"/></td>
                            <td align="right">${endereco.numero == 0 ? '-' : endereco.numero}</td>
                            <td align="center"><c:out value="${endereco.bairro}"/></td>
                            <td align="center"><c:out value="${endereco.cidade}"/>/<c:out value="${endereco.estado}"/></td>
                            <td align="center"><c:out value="${endereco.cep}"/></td>
                            <td align="center">
                                <a class="btn btn-sm btn-primary"
                                   href="${pageContext.request.contextPath}/EnderecoCarregar?id=${endereco.id}&amp;origem=${origem}">Alterar</a>
                            </td>
                            <td align="center">
                                <button type="button" class="btn btn-sm btn-danger"
                                        onclick="deletar(${endereco.id})">Excluir</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    var URL_LISTA = '${pageContext.request.contextPath}/EnderecoListar?usuarioId=${usuarioId}&origem=${origem}';

    $(document).ready(function () {
        $('#datatable').DataTable({
            "oLanguage": {
                "sProcessing": "Processando...",
                "sLengthMenu": "Mostrar _MENU_ registros",
                "sZeroRecords": "Nenhum endereço cadastrado.",
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
            confirmButtonText: 'Sim, apague o endereço!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (!result.isConfirmed) {
                return;
            }
            $.ajax({
                type: 'post',
                url: '${pageContext.request.contextPath}/EnderecoExcluir',
                data: { id: id },
                success: function (data) {
                    var ok = (String(data).trim() === '1');
                    Swal.fire({
                        position: 'center',
                        icon: ok ? 'success' : 'error',
                        title: ok ? 'Sucesso' : 'Erro',
                        text: ok ? 'Endereço excluído com sucesso!'
                                 : 'Não foi possível excluir o endereço!',
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function () {
                        window.location.href = URL_LISTA;
                    });
                },
                error: function () {
                    window.location.href = URL_LISTA;
                }
            });
        });
    }
</script>
<jsp:include page="/footer.jsp"/>
