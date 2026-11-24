<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Consumidores</h1>
    <p class="mb-4">Formulário de Cadastro</p>

    <a class="btn btn-secondary mb-4" href="${pageContext.request.contextPath}/ConsumidorListar">
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
                               value="${consumidor.id}" readonly="readonly"/>
                    </div>
                    <div class="form-group">
                        <label>Nome</label>
                        <input class="form-control" type="text" name="nome" id="nome"
                               value="<c:out value='${consumidor.nome}'/>" maxlength="100"
                               placeholder="Seu nome completo"/>
                    </div>
                    <div class="form-group">
                        <label>CPF</label>
                        <input class="form-control" type="text" name="cpf" id="cpf"
                               value="<c:out value='${consumidor.cpf}'/>" maxlength="14"
                               placeholder="Seu cpf sem pontos, apenas os números"/>
                    </div>
                    <div class="form-group">
                        <label>E-mail</label>
                        <input class="form-control" type="email" name="email" id="email"
                               value="<c:out value='${consumidor.email}'/>" maxlength="100"
                               placeholder="Ex.: nome@dominio.com"/>
                    </div>
                    <div class="form-group">
                        <label>Telefone</label>
                        <input class="form-control" type="tel" name="telefone" id="telefone"
                               value="<c:out value='${consumidor.telefone}'/>" maxlength="20"
                               placeholder="Ex.: (12) 34567-8901"/>
                    </div>
                    <div class="form-group">
                        <label>Senha</label>
                        <input class="form-control" type="password" name="senha" id="senha"
                               maxlength="100" autocomplete="new-password"
                               placeholder="${consumidor.id != 0 ? 'Deixe em branco para manter a senha atual' : 'Crie uma senha forte com números, letras e símbolos'}"/>
                    </div>
                    <div class="form-group">
                        <label>Forma de pagamento</label>
                        <select class="form-control" name="dadosPagamento" id="dadosPagamento">
                            <option value="">Selecione...</option>
                            <option value="PIX" ${consumidor.dadosPagamento == 'PIX' ? 'selected' : ''}>PIX</option>
                            <option value="CARTAO_CREDITO" ${consumidor.dadosPagamento == 'CARTAO_CREDITO' ? 'selected' : ''}>Cartão de crédito</option>
                            <option value="CARTAO_DEBITO" ${consumidor.dadosPagamento == 'CARTAO_DEBITO' ? 'selected' : ''}>Cartão de débito</option>
                            <option value="BOLETO" ${consumidor.dadosPagamento == 'BOLETO' ? 'selected' : ''}>Boleto</option>
                        </select>
                    </div>
                    <hr/>
                    <h5 class="mb-3">Endereço</h5>
                    <input type="hidden" name="enderecoId" id="enderecoId"
                           value="${consumidor.endereco[0].id}"/>
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>CEP</label>
                            <input class="form-control" type="text" name="cep" id="cep"
                                   value="<c:out value='${consumidor.endereco[0].cep}'/>" maxlength="9"
                                   placeholder="CEP da sua localidade, ex.: 12345-678"/>
                        </div>
                        <div class="form-group col-md-8">
                            <label>Logradouro</label>
                            <input class="form-control" type="text" name="logradouro" id="logradouro"
                                   value="<c:out value='${consumidor.endereco[0].logradouro}'/>" maxlength="150"
                                   placeholder="Nome da rua"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-3">
                            <label>Número</label>
                            <input class="form-control" type="text" name="numero" id="numero"
                                   value="${consumidor.endereco[0].numero == 0 ? '' : consumidor.endereco[0].numero}"
                                   maxlength="9" placeholder="Número da casa ou apartamento"/>
                        </div>
                        <div class="form-group col-md-9">
                            <label>Complemento</label>
                            <input class="form-control" type="text" name="complemento" id="complemento"
                                   value="<c:out value='${consumidor.endereco[0].complemento}'/>" maxlength="100"
                                   placeholder="Informação para ajudar a encontrar o local"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-5">
                            <label>Bairro</label>
                            <input class="form-control" type="text" name="bairro" id="bairro"
                                   value="<c:out value='${consumidor.endereco[0].bairro}'/>" maxlength="100"
                                   placeholder="Digite o nome do bairro"/>
                        </div>
                        <div class="form-group col-md-5">
                            <label>Cidade</label>
                            <input class="form-control" type="text" name="cidade" id="cidade"
                                   value="<c:out value='${consumidor.endereco[0].cidade}'/>" maxlength="100"
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
                        <c:if test="${consumidor.id != 0}">
                            <a class="btn btn-info"
                               href="${pageContext.request.contextPath}/EnderecoListar?usuarioId=${consumidor.id}">Endereços</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    var CTX = '${pageContext.request.contextPath}';
    var ESTADO_ATUAL = '<c:out value="${consumidor.endereco[0].estado}"/>';
    var UFS = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
               'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'];

    var MENSAGENS = {
        '3':  {titulo: 'CPF inválido!',                campo: '#cpf'},
        '4':  {titulo: 'CPF já cadastrado!',           campo: '#cpf'},
        '5':  {titulo: 'Informe o e-mail!',            campo: '#email'},
        '6':  {titulo: 'Formato de e-mail inválido!',  campo: '#email'},
        '7':  {titulo: 'E-mail já cadastrado!',        campo: '#email'},
        '8':  {titulo: 'Informe o nome!',              campo: '#nome'},
        '9':  {titulo: 'Informe a senha!',             campo: '#senha'},
        '10': {titulo: 'Forma de pagamento inválida!', campo: '#dadosPagamento'},
        '11': {titulo: 'CEP inválido!',          campo: '#cep'},
        '12': {titulo: 'Informe o logradouro!',  campo: '#logradouro'},
        '13': {titulo: 'Informe a cidade!',      campo: '#cidade'},
        '14': {titulo: 'Selecione o estado!',    campo: '#estado'}
    };

    $(document).ready(function () {
        // lista de estados (UF)
        var opcoes = '<option value="">UF</option>';
        for (var i = 0; i < UFS.length; i++) {
            opcoes += '<option value="' + UFS[i] + '">' + UFS[i] + '</option>';
        }
        $('#estado').html(opcoes).val(ESTADO_ATUAL);

        // máscara do CEP
        $('#cep').mask('99999-999');
        
        // mostra o CPF já formatado quando o formulário abre para edição
        if ($('#cpf').val() !== '') {
            trocaMascara($('#cpf').val());
        }

        $('#cpf').focus(function () {
            trocaMascara();
            this.select();
        });

        $('#cpf').blur(function () {
            var cpfLimpo = $('#cpf').unmask().val();

            if (!validarCpfCnpj(cpfLimpo)) {
                Swal.fire({
                    position: 'center',
                    icon: 'error',
                    title: 'Verifique o CPF!',
                    showConfirmButton: true,
                    timer: 10000
                });
            } else {
                trocaMascara($('#cpf').val());
                $.ajax({
                    type: 'get',
                    url: CTX + '/UsuarioVerificarCpf',
                    data: { cpf: cpfLimpo, id: $('#id').val() },
                    success: function (response) {
                        if (String(response).trim() === '1') {
                            Swal.fire({
                                position: 'center',
                                icon: 'warning',
                                title: 'CPF já cadastrado!',
                                text: 'Por favor, verifique o CPF informado.',
                                showConfirmButton: true,
                                timer: 4000
                            }).then(function () {
                                $('#nome').focus();
                            });
                        }
                    },
                    error: function () {
                        console.log('Erro ao verificar CPF no servidor.');
                    }
                });
            }
        });

        var emailVerificado = '';

        $('#email').blur(function () {
            var emailLimpo = $('#email').val().trim().toLowerCase();

            if (emailLimpo === '') {
                Swal.fire({
                    position: 'center',
                    icon: 'error',
                    title: 'Informe o e-mail!',
                    text: 'O e-mail não pode ficar em branco.',
                    showConfirmButton: true,
                    timer: 10000
                });
            } else if (!validarEmail(emailLimpo)) {
                Swal.fire({
                    position: 'center',
                    icon: 'error',
                    title: 'Verifique o E-mail!',
                    text: 'Informe um e-mail válido, exemplo: nome@dominio.com',
                    showConfirmButton: true,
                    timer: 10000
                });
            } else {
                if (emailLimpo === emailVerificado) {
                    return;
                }
                emailVerificado = emailLimpo;
                $.ajax({
                    type: 'get',
                    url: CTX + '/UsuarioVerificarEmail',
                    data: { email: emailLimpo, id: $('#id').val() },
                    success: function (response) {
                        if (String(response).trim() === '1') {
                            Swal.fire({
                                position: 'center',
                                icon: 'warning',
                                title: 'E-mail já cadastrado!',
                                text: 'Por favor, verifique o e-mail informado.',
                                showConfirmButton: true,
                                timer: 4000
                            }).then(function () {
                                $('#email').val('');
                                emailVerificado = '';
                                setTimeout(function () {
                                    $('#email').focus();
                                }, 50);
                            });
                        }
                    },
                    error: function () {
                        emailVerificado = '';
                        console.log('Erro ao verificar e-mail no servidor.');
                    }
                });
            }
        });

        $('#nome').focus();
    });

    function trocaMascara(cpf) {
        if (typeof cpf === 'undefined') {
            cpf = '';
        }
        cpf = cpf.trim();

        if (cpf !== '') {
            $('#cpf').unmask().mask('999.999.999-99');
        } else {
            $('#cpf').unmask();
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
        var editando = $('#id').val() != 0;
        var enderecoPreenchido = $('#cep').val().replace(/\D/g, '') !== '' ||
            $('#logradouro').val().trim() !== '' || $('#numero').val().trim() !== '' ||
            $('#complemento').val().trim() !== '' || $('#bairro').val().trim() !== '' ||
            $('#cidade').val().trim() !== '' || $('#estado').val() !== '';
        var validaEndereco = !editando || enderecoPreenchido;

        if ($('#nome').val().trim() === '') {
            aviso('Verifique o nome do consumidor!', '#nome');
        } else if ($('#cpf').val().trim() === '') {
            aviso('Verifique o CPF!', '#cpf');
        } else if ($('#email').val().trim() === '') {
            aviso('Informe o e-mail!', '#email');
        } else if (!validarEmail($('#email').val().trim())) {
            aviso('Formato de e-mail inválido!', '#email');
        } else if (!editando && $('#senha').val() === '') {
            aviso('Verifique a senha!', '#senha');
        } else if ($('#dadosPagamento').val() === '') {
            aviso('Selecione a forma de pagamento!', '#dadosPagamento');
        } else if (validaEndereco && $('#cep').val().replace(/\D/g, '').length !== 8) {
            aviso('Verifique o CEP!', '#cep');
        } else if (validaEndereco && $('#logradouro').val().trim() === '') {
            aviso('Informe o logradouro!', '#logradouro');
        } else if (validaEndereco && $('#cidade').val().trim() === '') {
            aviso('Informe a cidade!', '#cidade');
        } else if (validaEndereco && $('#estado').val() === '') {
            aviso('Selecione o estado!', '#estado');
        } else {
            gravarDados();
        }
    }
 
    function gravarDados() {
        $.ajax({
            type: 'post',
            url: CTX + '/ConsumidorCadastrar',
            data: {
                id: $('#id').val(),
                nome: $('#nome').val().trim(),
                cpf: $('#cpf').unmask().val(),
                email: $('#email').val().trim().toLowerCase(),
                telefone: $('#telefone').val().trim(),
                senha: $('#senha').val(),
                dadosPagamento: $('#dadosPagamento').val(),
                enderecoId: $('#enderecoId').val(),
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
                        text: 'Consumidor gravado com sucesso!',
                        showConfirmButton: true,
                        timer: 3000
                    }).then(function () {
                        window.location.href = CTX + '/ConsumidorListar';
                    });
                } else {
                    var m = MENSAGENS[codigo] ||
                            {titulo: 'Não foi possível gravar o consumidor!', campo: '#nome'};
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
