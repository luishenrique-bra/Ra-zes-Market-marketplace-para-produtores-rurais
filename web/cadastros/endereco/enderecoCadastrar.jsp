<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="origem" value="${param.origem == 'ProdutorListar' ? 'ProdutorListar' : 'ConsumidorListar'}"/>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Endereços</h1>
    <p class="mb-4">Formulário de Endereço</p>

    <a class="btn btn-secondary mb-4"
       href="${pageContext.request.contextPath}/EnderecoListar?usuarioId=${endereco.usuarioId}&amp;origem=${origem}">
        <i class="fas fa-undo-alt"></i>
        <strong>Voltar</strong>
    </a>
    <div class="row">
        <div class="col-lg-9">
            <div class="card shadow mb-4">
                <div class="card-body">
                    <input type="hidden" name="id" id="id" value="${endereco.id}"/>
                    <input type="hidden" name="usuarioId" id="usuarioId" value="${endereco.usuarioId}"/>

                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>CEP</label>
                            <input class="form-control" type="text" name="cep" id="cep"
                                   value="<c:out value='${endereco.cep}'/>" maxlength="9"
                                   placeholder="CEP da sua localidade, ex.: 12345-678"/>
                        </div>
                        <div class="form-group col-md-8">
                            <label>Logradouro</label>
                            <input class="form-control" type="text" name="logradouro" id="logradouro"
                                   value="<c:out value='${endereco.logradouro}'/>" maxlength="150"
                                   placeholder="Nome da rua"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-3">
                            <label>Número</label>
                            <input class="form-control" type="text" name="numero" id="numero"
                                   value="${endereco.numero == 0 ? '' : endereco.numero}" maxlength="9"
                                   placeholder="Número da casa ou apartamento"/>
                        </div>
                        <div class="form-group col-md-9">
                            <label>Complemento</label>
                            <input class="form-control" type="text" name="complemento" id="complemento"
                                   value="<c:out value='${endereco.complemento}'/>" maxlength="100"
                                   placeholder="Informação para ajudar a encontrar o local"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-5">
                            <label>Bairro</label>
                            <input class="form-control" type="text" name="bairro" id="bairro"
                                   value="<c:out value='${endereco.bairro}'/>" maxlength="100"
                                   placeholder="Digite o nome do bairro"/>
                        </div>
                        <div class="form-group col-md-5">
                            <label>Cidade</label>
                            <input class="form-control" type="text" name="cidade" id="cidade"
                                   value="<c:out value='${endereco.cidade}'/>" maxlength="100"]
                                   placeholder="Digite o nome da cidade"/>
                        </div>
                        <div class="form-group col-md-2">
                            <label>Estado</label>
                            <select class="form-control" name="estado" id="estado"></select>
                        </div>
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
    var ESTADO_ATUAL = '<c:out value="${endereco.estado}"/>';
    var UFS = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
               'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'];

    var MENSAGENS = {
        '2': {titulo: 'Usuário não informado!',  campo: '#cep'},
        '3': {titulo: 'Informe a cidade!',        campo: '#cidade'},
        '4': {titulo: 'Selecione o estado!',      campo: '#estado'},
        '5': {titulo: 'Informe o logradouro!',    campo: '#logradouro'},
        '6': {titulo: 'CEP inválido!',            campo: '#cep'}
    };

    $(document).ready(function () {
        var opcoes = '<option value="">UF</option>';
        for (var i = 0; i < UFS.length; i++) {
            opcoes += '<option value="' + UFS[i] + '">' + UFS[i] + '</option>';
        }
        $('#estado').html(opcoes).val(ESTADO_ATUAL);

        $('#cep').mask('99999-999');
        $('#cep').focus();
    });

    function urlLista() {
        return CTX + '/EnderecoListar?usuarioId=' + $('#usuarioId').val() + '&origem=${origem}';
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
        if ($('#cep').val().replace(/\D/g, '').length !== 8) {
            aviso('Verifique o CEP!', '#cep');
        } else if ($('#logradouro').val().trim() === '') {
            aviso('Informe o logradouro!', '#logradouro');
        } else if ($('#cidade').val().trim() === '') {
            aviso('Informe a cidade!', '#cidade');
        } else if ($('#estado').val() === '') {
            aviso('Selecione o estado!', '#estado');
        } else {
            gravarDados();
        }
    }

    function gravarDados() {
        $.ajax({
            type: 'post',
            url: CTX + '/EnderecoCadastrar',
            data: {
                id: $('#id').val(),
                usuarioId: $('#usuarioId').val(),
                cep: $('#cep').val(),
                logradouro: $('#logradouro').val().trim(),
                numero: $('#numero').val().trim(),
                complemento: $('#complemento').val().trim(),
                bairro: $('#bairro').val().trim(),
                cidade: $('#cidade').val().trim(),
                estado: $('#estado').val()
            },
            success: function (data) {
                var codigo = String(data).trim();
                if (codigo === '1') {
                    Swal.fire({
                        position: 'center',
                        icon: 'success',
                        title: 'Sucesso',
                        text: 'Endereço gravado com sucesso!',
                        showConfirmButton: true,
                        timer: 3000
                    }).then(function () {
                        window.location.href = urlLista();
                    });
                } else {
                    var m = MENSAGENS[codigo] ||
                            {titulo: 'Não foi possível gravar o endereço!', campo: '#cep'};
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
