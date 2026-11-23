<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Produtos</h1>
    <p class="mb-4">Formulário de Cadastro</p>

    <a class="btn btn-secondary mb-4" href="${pageContext.request.contextPath}/ProdutoListar">
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
                               value="${produto.id}" readonly="readonly"/>
                    </div>
                    <div class="form-group">
                        <label>Nome</label>
                        <input class="form-control" type="text" name="nome" id="nome" 
                               value="<c:out value='${produto.nome}'/>" maxlength="100"
                               placeholder="Nome do produto"/>
                    </div>
                    <div class="form-group">
                        <label for="peso">Peso</label>
                        <input class="form-control" type="text" name="peso" id="peso"
                                value="<c:choose><c:when test="${produto.peso > 0 && produto.peso < 1}"><fmt:formatNumber value="${produto.peso * 1000}" maxFractionDigits="0"/>g</c:when><c:when test="${produto.peso >= 1}"><fmt:formatNumber value="${produto.peso}" maxFractionDigits="2"/>kg</c:when></c:choose>"
                                placeholder="Informe o peso (ex: 500g ou 1kg)"/>
                    </div>
                    <div class="form-group">
                        <label for="preco">Preço</label>
                        <input class="form-control" type="text" name="preco" id="preco"
                                value="<c:if test="${produto.preco != 0}">${produto.preco}</c:if>"
                                placeholder="Informe o preço (ex: 29.90)"/>
                    </div>
                    <div class="form-group">
                        <label for="qtdeEstoque">Quantidade Estoque</label>
                        <input class="form-control" type="number" name="qtdeEstoque" id="qtdeEstoque"
                                value="<c:if test="${produto.qtdeEstoque != 0}">${produto.qtdeEstoque}</c:if>"
                                placeholder="Informe a quantidade em estoque"/>
                    </div>
                    <div class="form-group">
                        <button class="btn btn-success" type="button" id="salvar" onclick="validarCampos()">
                            Salvar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var CTX = '${pageContext.request.contextPath}';

    var MENSAGENS = {
        '3':  {titulo: 'Informe o nome do produto!', campo: '#nome'},
        '4':  {titulo: 'Informe o peso do produto!', campo: '#peso'},
        '5':  {titulo: 'O peso deve ser maior que zero!', campo: '#peso'},
        '6':  {titulo: 'Informe o preço do produto!', campo: '#preco'},
        '7':  {titulo: 'O preço deve ser maior que zero!', campo: '#preco'},
        '8':  {titulo: 'Informe a quantidade em estoque!', campo: '#qtdeEstoque'},
        '9':  {titulo: 'A quantidade em estoque é inválida!', campo: '#qtdeEstoque'}
    };

    $(document).ready(function () {
        // Validação/Formatação visual do peso ao sair do campo
        $('#peso').blur(function () {
            var valor = $(this).val().trim().toLowerCase();
            if (valor === '') return;

            if (valor.endsWith('g') && !valor.endsWith('kg')) {
                var gramas = parseFloat(valor.replace('g', '').replace(',', '.').trim());
                if (!isNaN(gramas) && gramas > 0) {
                    if (gramas < 1000) {
                        $(this).val(gramas + 'g');
                    } else {
                        $(this).val((gramas / 1000) + 'kg');
                    }
                } else {
                    avisoPesoInvalido();
                }
            } 
            else if (valor.endsWith('kg')) {
                var quilos = parseFloat(valor.replace('kg', '').replace(',', '.').trim());
                if (!isNaN(quilos) && quilos > 0) {
                    $(this).val(quilos + 'kg');
                } else {
                    avisoPesoInvalido();
                }
            } 
            else {
                var numero = parseFloat(valor.replace(',', '.'));
                if (isNaN(numero) || numero <= 0) {
                    avisoPesoInvalido();
                } else {
                    if (numero >= 10) {
                        $(this).val(numero + 'g');
                    } else {
                        $(this).val(numero + 'kg');
                    }
                }
            }
        });
    });

    function avisoPesoInvalido() {
        Swal.fire({
            position: 'center',
            icon: 'error',
            title: 'Informe um peso válido!',
            text: 'Exemplos de formato aceito: 500g ou 1kg.',
            showConfirmButton: true,
            timer: 3000
        });
        $('#peso').val('');
    }

    // Função de conversão acessível globalmente
    function obterPesoEmQuilos() {
        var valor = $('#peso').val().trim().toLowerCase();
        if (valor === '') return 0;
        
        if (valor.endsWith('g') && !valor.endsWith('kg')) {
            var gramas = parseFloat(valor.replace('g', '').replace(',', '.'));
            return isNaN(gramas) ? 0 : (gramas / 1000);
        } else {
            var quilos = parseFloat(valor.replace('kg', '').replace(',', '.'));
            return isNaN(quilos) ? 0 : quilos;
        }
    }

    function aviso(titulo, campo) {
        Swal.fire({
            position: 'center',
            icon: 'error',
            title: titulo,
            showConfirmButton: false,
            timer: 1500
        });
        $(campo).focus();
    }

    function validarCampos() {
        var pesoQuilos = obterPesoEmQuilos();
        var preco = parseFloat($('#preco').val().replace(',', '.'));
        var qtdeEstoque = parseInt($('#qtdeEstoque').val());

        if ($('#nome').val().trim() === '') {
            aviso('Informe o nome do produto!', '#nome');
        } else if ($('#peso').val().trim() === '' || pesoQuilos <= 0) {
            aviso('Informe um peso válido!', '#peso');
        } else if ($('#preco').val().trim() === '' || isNaN(preco) || preco <= 0) {
            aviso('Informe um preço válido!', '#preco');
        } else if ($('#qtdeEstoque').val().trim() === '' || isNaN(qtdeEstoque) || qtdeEstoque < 0) {
            aviso('Informe uma quantidade válida!', '#qtdeEstoque');
        } else {
            gravarDados();
        }
    }

    function gravarDados() {
        $.ajax({
            type: 'post',
            url: CTX + '/ProdutoCadastrar',
            data: {
                id: $('#id').val(),
                nome: $('#nome').val().trim(),
                peso: obterPesoEmQuilos(),
                preco: $('#preco').val(),
                qtdeEstoque: $('#qtdeEstoque').val()
            },
            success: function (data) {
                var codigo = String(data).trim();

                if (codigo === '1') {
                    Swal.fire({
                        position: 'center',
                        icon: 'success',
                        title: 'Sucesso',
                        text: 'Produto gravado com sucesso!',
                        showConfirmButton: true,
                        timer: 3000
                    }).then(function () {
                        window.location.href = CTX + '/ProdutoListar';
                    });
                } else {
                    var m = MENSAGENS[codigo] || {titulo: 'Não foi possível gravar o produto!', campo: '#nome'};

                    Swal.fire({
                        position: 'center',
                        icon: 'error',
                        title: m.titulo,
                        showConfirmButton: true,
                        timer: 5000
                    }).then(function () {
                        setTimeout(function () {
                            $(m.campo).focus();
                        }, 50);
                    });
                }
            },
            error: function () {
                Swal.fire({
                    position: 'center',
                    icon: 'error',
                    title: 'Erro de comunicação',
                    text: 'Falha na comunicação com o servidor.',
                    showConfirmButton: true,
                    timer: 5000
                });
            }
        });
    }
</script>
<jsp:include page="/footer.jsp"/>