<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="iso-8859-1"%>
<c:set var="origem" value="${param.origem == 'ProdutorListar' ? 'ProdutorListar' : 'ConsumidorListar'}"/>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Endere?os</h1>
    <p class="mb-4">Cadastro de Endere?os</p>
    
    <a class="btn btn-secondary mb-4" href="${pageContext.request.contextPath}/${origem}">
        <i class="fas fa-undo-alt"></i>
        <strong>Voltar</strong>
    </a>
    <a class="btn btn-success mb-4" href="${pageContext.request.contextPath}/EnderecoNovo?usuarioId=${usuarioId}&origem=${origem}">
        <i class="fas fa-sticky-note"></i>
        <strong>Novo</strong>
    </a>
    
    <div class="card shadow">
        <div class="card-body">
            <table id="datatable" class="display">
                <thead>
                    <tr>
                        <th align="right">Id</th>
                        <th align="left">Logradouro</th>
                        <th align="right">Número</th>
                        <th align="left">Bairro</th>
                        <th align="left">Cidade/UF</th>
                        <th align="left">CEP</th>
                        <th Align="center">Excluir</th>
                        <th Align="center">Alterar</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="endereco" items="${lista}"> 
                        <tr>
                            <td align="right">${endereco.id}</td>
                            <td align="center"><c:out value="${endereco.logradouro}"/></td>
                            <td align="center">${endereco.numero == 0 ? '-' : endereco.numero}</td>
                            <td align="center"><c:out value="${endereco.bairro}"/></td>
                            <td align="center"><c:out value="${endereco.cidade}"/>/<c:out value="${endereco.estado}"/></td>
                            <td align="left"><c:out value="${endereco.cep}"/></td>
                            <td align="center">
                                <a href="#" title="Excluir" onclick="deletar(${endereco.id}); return false;">
                                    <button>Excluir</button>
                                </a>
                            </td>                         
                            <td align="center">
                                <a href="${pageContext.request.contextPath}/EnderecoCarregar?id=${endereco.id}&origem=${origem}">
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
    var URL_LISTA = "${pageContext.request.contextPath}/EnderecoListar?usuarioId=${usuarioId}&origem=${origem}";

    $(document).ready(function() {
            console.log('entrei ready');
            $('#datatable').DataTable({
                "oLanguage": {
                    "sProcessing": "Processando...",
                    "sLengthMenu": "Mostrar _MENU_ registros",
                    "sZeroRecords": "Nenhum endere?o cadastrado.",
                    "sInfo": "Mostrando de _START_ at? _END_ de _TOTAL_ registros",
                    "sInfoEmpty": "Mostrando de 0 at? 0 de 0 registros",
                    "sInfoFiltered": "",
                    "sInfoPostFix": "",
                    "sSearch": "Buscar:",
                    "sUrl": "",
                    "oPaginate": {
                        "sFirst": "Primeiro",
                        "sPrevious": "Anterior",
                        "sNext": "Seguinte",
                        "sLast": "?ltimo"
                    }
                }
            });
        });
        
    function deletar(id){
        Swal.fire({
            title: 'Voc? tem certeza?',
            text: "Voc? n?o poder? recuperar depois!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sim, apague o endere?o!',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    type: 'post',
                    url: '${pageContext.request.contextPath}/EnderecoExcluir',
                    data:{
                        id: id
                    },
                    success:
                        function(data){
                            var ok = (String(data).trim() === '1');
                            Swal.fire({
                                position: 'top-end',
                                icon: ok ? 'success' : 'error',
                                title: ok ? 'Sucesso' : 'Erro',
                                text: ok ? 'Endere?o exclu?do com sucesso!' : 'N?o foi poss?vel excluir o endere?o!',
                                showConfirmButton: false,
                                timer: 2000
                            }).then(function () {
                                window.location.href = URL_LISTA;
                            });
                        },
                    error:
                        function(data){
                            window.location.href = URL_LISTA;
                        }
                });
            };
        });
    }
</script>
 <%@include file="/footer.jsp"%>
