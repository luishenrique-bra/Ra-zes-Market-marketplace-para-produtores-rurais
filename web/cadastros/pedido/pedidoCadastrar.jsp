<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Pedidos</h1>
    <p class="mb-4">Formulário de Cadastro</p>

    <a class="btn btn-secondary mb-4" href="${pageContext.request.contextPath}/PedidoListar">
        <i class="fas fa-undo-alt"></i>
        <strong>Voltar</strong>
    </a>
    <div class="row">
        <div class="col-lg-9">
            <div class="card shadow mb-4">
                <div class="card-body">
                    
                    <div class="form-group">
                        <label>Id</label>
                        <input class="form-control" type="text" name="id" id="id"
                               value="${pedido.id}" readonly="readonly"/>
                    </div>
                    
                    <!-- Campo de Data preenchido com a data atual -->
                    <div class="form-group">
                        <label>Data</label>
                        <input class="form-control" type="date" name="dataPedido" id="dataPedido" readonly="readonly"
                                value="<fmt:formatDate value='${pedido.dataPedidoDate}' pattern='yyyy-MM-dd'/>"/>
                    </div>
                    
                    <!-- O Status só aparece caso o pedido já exista -->
                    <c:if test="${pedido.id != 0}">
                        <div class="form-group">
                            <label>Status</label>
                            <input class="form-control" type="text" name="status" id="status"
                                   value="<c:out value='${pedido.status}'/>" readonly="readonly"/>
                        </div>
                    </c:if>

                    <c:if test="${pedido.status == 'CANCELADO'}">
                        <div class="form-group">
                            <label>Motivo do Cancelamento</label>
                            <input class="form-control" type="text" name="motivoCancelamento" id="motivoCancelamento"
                                   value="<c:out value='${pedido.motivoCancelamento}'/>" readonly="readonly"/>
                        </div>
                        <div class="form-group">
                            <label>Data do Cancelamento</label>
                            <input class="form-control" type="text" name="dataCancelamento" id="dataCancelamento"
                                   value="<fmt:formatDate value='${pedido.dataCancelamentoDate}' pattern='dd/MM/yyyy HH:mm'/>" readonly="readonly"/>
                        </div>
                    </c:if>

                    <!-- Secção dos Itens do Pedido com adição dinâmica de produtos -->
                    <div class="form-group">
                        <label><strong>Itens do Pedido</strong></label>
                        <table class="table table-bordered table-dark" id="tabelaItens">
                            <thead class="thead-dark">
                                <tr>
                                    <th>Produto</th>
                                    <th width="150">Quantidade</th>
                                    <th width="80" class="text-center">Remover</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${pedido.itens}">
                                <tr>
                                    <td>
                                        <select class="form-control bg-dark text-white border-secondary produto-id">
                                            <option value="">Selecione um produto...</option>
                                            <c:forEach var="prod" items="${produtos}">
                                                <option value="${prod.id}" ${prod.id == item.produtoId ? 'selected' : ''}>
                                                    ${prod.nome}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="number" class="form-control bg-dark text-white border-secondary quantidade" value="${item.quantidade}" min="1"/>
                                    </td>
                                    <td align="center">
                                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="removerItem(this)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <button type="button" class="btn btn-primary btn-sm" onclick="adicionarItem()">
                            <i class="fas fa-plus"></i> Adicionar Produto
                        </button>
                    </div>

                    <!-- Template oculto de opções de produtos para o JavaScript clonar -->
                    <select id="templateProdutos" style="display: none;">
                        <option value="">Selecione um produto...</option>
                        <c:forEach var="prod" items="${produtos}">
                            <option value="${prod.id}">${prod.nome}</option>
                        </c:forEach>
                    </select>

                    <div class="form-group mt-4">
                        <button class="btn btn-success" type="button" id="salvar" onclick="validarCampos()">
                            Salvar Pedido
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var CTX = '${pageContext.request.contextPath}';

    // Adiciona uma nova linha clonando as opções do template
    function adicionarItem() {
        var optionsHtml = $('#templateProdutos').html();

        var novaLinha = `
            <tr>
                <td>
                    <select class="form-control bg-dark text-white border-secondary produto-id">
                        ` + optionsHtml + `
                    </select>
                </td>
                <td>
                    <input type="number" class="form-control bg-dark text-white border-secondary quantidade" value="1" min="1"/>
                </td>
                <td align="center">
                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="removerItem(this)">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
        $('#tabelaItens tbody').append(novaLinha);
    }

    function removerItem(btn) {
        $(btn).closest('tr').remove();
    }

    function aviso(titulo, campo) {
        Swal.fire({
            position: 'center',
            icon: 'error',
            title: titulo,
            showConfirmButton: false,
            timer: 1500
        });
        if (campo) $(campo).focus();
    }

    function validarCampos() {
        var qtdItens = $('#tabelaItens tbody tr').length;
        if (qtdItens === 0) {
            aviso('Adicione pelo menos um produto ao pedido!');
            return;
        }

        var produtoInvalido = false;
        $('#tabelaItens tbody tr').each(function () {
            var prodId = $(this).find('.produto-id').val();
            var qtd = $(this).find('.quantidade').val();
            if (!prodId || prodId === '' || parseInt(qtd) <= 0) {
                produtoInvalido = true;
            }
        });

        if (produtoInvalido) {
            aviso('Selecione todos os produtos e informe quantidades válidas!');
        } else {
            gravarDados();
        }
    }

    function gravarDados() {
        var produtoIds = [];
        var quantidades = [];

        $('#tabelaItens tbody tr').each(function () {
            var pId = $(this).find('.produto-id').val();
            var q = $(this).find('.quantidade').val();
            if (pId && q) {
                produtoIds.push(pId);
                quantidades.push(q);
            }
        });

        $.ajax({
            type: 'post',
            url: CTX + '/PedidoCadastrar',
            data: {
                id: $('#id').val(),
                dataPedido: $('#dataPedido').val(),
                produtoId: produtoIds,
                quantidade: quantidades
            },
            traditional: true,
            success: function (data) {
                var codigo = String(data).trim();
                if (codigo === '1') {
                    Swal.fire({
                        position: 'center',
                        icon: 'success',
                        title: 'Sucesso',
                        text: 'Pedido gravado com sucesso!',
                        showConfirmButton: true,
                        timer: 2000
                    }).then(function () {
                        window.location.href = CTX + '/PedidoListar';
                    });
                } else {
                    Swal.fire({
                        position: 'center',
                        icon: 'error',
                        title: 'Não foi possível gravar o pedido!',
                        text: 'Código do erro: ' + (codigo || 'Desconhecido'),
                        showConfirmButton: true,
                        timer: 4000
                    });
                }
            },
            error: function (xhr, status, error) {
                Swal.fire({
                    position: 'center',
                    icon: 'error',
                    title: 'Erro de Comunicação',
                    text: 'Falha no servidor: ' + status,
                    showConfirmButton: true,
                    timer: 4000
                });
            }
        });
    }
</script>
<jsp:include page="/footer.jsp"/>