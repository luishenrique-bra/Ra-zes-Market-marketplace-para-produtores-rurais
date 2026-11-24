<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Produtores</h1>
    <p class="mb-4">Formulário de Cadastro</p>

    <a class="btn btn-secondary mb-4" href="${pageContext.request.contextPath}/ProdutorListar">
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
                               value="${produtor.id}" readonly="readonly"/>
                    </div>
                    <div class="form-group">
                        <label>Nome</label>
                        <input class="form-control" type="text" name="nome" id="nome"
                               value="<c:out value='${produtor.nome}'/>" maxlength="100"
                               placeholder="Seu nome completo"/>
                    </div>
                    <div class="form-group">
                        <label>Nome da Propriedade</label>
                        <input class="form-control" type="text" name="nomePropriedade" id="nomePropriedade"
                               value="<c:out value='${produtor.nomePropriedade}'/>" maxlength="100"
                               placeholder="Nome da sua propriedade"/>
                    </div>
                    <div class="form-group">
                        <label>CPF</label>
                        <input class="form-control" type="text" name="cpf" id="cpf"
                               value="<c:out value='${produtor.cpf}'/>" maxlength="14"
                               placeholder="Seu cpf sem pontos, apenas os números"/>
                    </div>
                    <div class="form-group">
                        <label>CNPJ</label>
                        <input class="form-control" type="text" name="cnpj" id="cnpj"
                               value="<c:out value='${produtor.cnpj}'/>" maxlength="18"
                               placeholder="Seu cnpj sem pontos, apenas os números"/>
                    </div>
                    <div class="form-group">
                        <label>E-mail</label>
                        <input class="form-control" type="email" name="email" id="email"
                               value="<c:out value='${produtor.email}'/>" maxlength="100"
                               placeholder="Ex.: nome@dominio.com"/>
                    </div>
                    <div class="form-group">
                        <label>Telefone</label>
                        <input class="form-control" type="tel" name="telefone" id="telefone"
                               value="<c:out value='${produtor.telefone}'/>" maxlength="20"
                               placeholder="Ex.: (12) 34567-8901"/>
                    </div>
                    <div class="form-group">
                        <label>Senha</label>
                        <input class="form-control" type="password" name="senha" id="senha"
                               maxlength="100" autocomplete="new-password"
                               placeholder="${produtor.id != 0 ? 'Deixe em branco para manter a senha atual' : 'Crie uma senha forte com números, letras e símbolos'}"/>
                    </div>
                    <hr/>
                    <h5 class="mb-3">Endereço</h5>
                    <input type="hidden" name="enderecoId" id="enderecoId"
                           value="${produtor.endereco[0].id}"/>
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>CEP</label>
                            <input class="form-control" type="text" name="cep" id="cep"
                                   value="<c:out value='${produtor.endereco[0].cep}'/>" maxlength="9"
                                   placeholder="CEP da sua localidade, ex.: 12345-678"/>
                        </div>
                        <div class="form-group col-md-8">
                            <label>Logradouro / Estrada</label>
                            <input class="form-control" type="text" name="logradouro" id="logradouro"
                                   value="<c:out value='${produtor.endereco[0].logradouro}'/>" maxlength="150"
                                   placeholder="Nome da rua ou estrada da propriedade"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-5">
                            <label>Cidade</label>
                            <input class="form-control" type="text" name="cidade" id="cidade"
                                   value="<c:out value='${produtor.endereco[0].cidade}'/>" maxlength="100"
                                   placeholder="Digite o nome da cidade "/>
                        </div>
                        <div class="form-group col-md-2">
                            <label>Estado</label>
                            <select class="form-control" name="estado" id="estado"></select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-5">
                            <label>Ponto de Referência</label>
                            <input class="form-control" type="text" name="complemento" id="complemento"
                                   value="<c:out value='${produtor.endereco[0].complemento}'/>" maxlength='100'
                                   placeholder="Ex.: Porteira 2, após 3 mata-burros"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <button class="btn btn-success" type="button" id="salvar" onclick="validarCampos()">
                            Salvar</button>
                        <c:if test="${produtor.id != 0}">
                            <a class="btn btn-info"
                               href="${pageContext.request.contextPath}/EnderecoListar?usuarioId=${produtor.id}">Endereços</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    var CTX = '${pageContext.request.contextPath}';
    var ESTADO_ATUAL = '<c:out value="${produtor.endereco[0].estado}"/>';
    var UFS = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
               'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'];

    var MENSAGENS = {
        '3':  {titulo: 'CPF inválido!',                    campo: '#cpf'},
        '4':  {titulo: 'CPF já cadastrado!',               campo: '#cpf'},
        '5':  {titulo: 'Informe o e-mail!',                campo: '#email'},
        '6':  {titulo: 'Formato de e-mail inválido!',      campo: '#email'},
        '7':  {titulo: 'E-mail já cadastrado!',            campo: '#email'},
        '8':  {titulo: 'Informe o nome!',                  campo: '#nome'},
        '9':  {titulo: 'Informe a senha!',                 campo: '#senha'},
        '10': {titulo: 'CNPJ inválido!',                   campo: '#cnpj'},
        '11': {titulo: 'CNPJ já cadastrado!',              campo: '#cnpj'},
        '12': {titulo: 'Informe o nome da propriedade!',   campo: '#nomePropriedade'},
        '13': {titulo: 'Informe o CPF ou o CNPJ!',         campo: '#cpf'},
        '14': {titulo: 'CEP inválido!',                    campo: '#cep'},
        '15': {titulo: 'Informe o logradouro!',            campo: '#logradouro'},
        '16': {titulo: 'Informe a cidade!',                campo: '#cidade'},
        '17': {titulo: 'Selecione o estado!',              campo: '#estado'}
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
            if (cpfLimpo === '') { return; }

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
        
        // mostra o CNPJ já formatado ao abrir para edição
        if ($('#cnpj').val() !== '') {
            trocaMascaraCnpj($('#cnpj').val());
        }

        $('#cnpj').focus(function () {
            trocaMascaraCnpj();
            this.select();
        });

        $('#cnpj').blur(function () {
            var cnpjLimpo = $('#cnpj').unmask().val();
            if (cnpjLimpo === '') { return; }

            if (cnpjLimpo !== '' && !validarCpfCnpj(cnpjLimpo)) {
                Swal.fire({
                    position: 'center',
                    icon: 'error',
                    title: 'Verifique o CNPJ!',
                    showConfirmButton: true,
                    timer: 10000
                });
            } else {
                trocaMascaraCnpj($('#cnpj').val());
                $.ajax({
                    type: 'get',
                    url: CTX + '/ProdutorVerificarCnpj',
                    data: { cnpj: cnpjLimpo, id: $('#id').val() },
                    success: function (response) {
                        if (String(response).trim() === '1') {
                            Swal.fire({
                                position: 'center',
                                icon: 'warning',
                                title: 'CNPJ já cadastrado!',
                                text: 'Por favor, verifique o CNPJ informado.',
                                showConfirmButton: true,
                                timer: 4000
                            }).then(function () {
                                $('#nome').focus();
                            });
                        }
                    },
                    error: function () {
                        console.log('Erro ao verificar CNPJ no servidor.');
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
    
    function trocaMascaraCnpj(cnpj) {
        if (typeof cnpj === 'undefined') {
            cnpj = '';
        }
        cnpj = cnpj.trim();

        if (cnpj !== '') {
            $('#cnpj').unmask().mask('99.999.999/9999-99');
        } else {
            $('#cnpj').unmask();
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
        var cepLimpo = $('#cep').val().replace(/\D/g, '');
        var editando = $('#id').val() != 0;
        var enderecoPreenchido = cepLimpo !== '' ||
            $('#logradouro').val().trim() !== '' || $('#cidade').val().trim() !== '' ||
            $('#complemento').val().trim() !== '' || $('#estado').val() !== '';
        var validaEndereco = !editando || enderecoPreenchido;

        if ($('#nome').val().trim() === '') {
            aviso('Verifique o nome do produtor!', '#nome');
        } else if ($('#nomePropriedade').val().trim() === '') {
            aviso('Verifique o nome da propriedade!', '#nomePropriedade');
        } else if ($('#cpf').val().trim() === '' && $('#cnpj').val().trim() === '') {
            aviso('Informe o CPF ou o CNPJ!', '#cpf');
        } else if ($('#email').val().trim() === '') {
            aviso('Informe o e-mail!', '#email');
        } else if (!validarEmail($('#email').val().trim())) {
            aviso('Formato de e-mail inválido!', '#email');
        } else if (!editando && $('#senha').val() === '') {
            aviso('Verifique a senha!', '#senha');
        } else if (validaEndereco && cepLimpo.length !== 8) {
            aviso('CEP inválido!', '#cep');
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
            url: CTX + '/ProdutorCadastrar',
            data: {
                id: $('#id').val(),
                nome: $('#nome').val().trim(),
                nomePropriedade: $('#nomePropriedade').val().trim(),
                cpf: $('#cpf').unmask().val(),
                cnpj: $('#cnpj').unmask().val(),
                email: $('#email').val().trim().toLowerCase(),
                telefone: $('#telefone').val().trim(),
                senha: $('#senha').val(),
                enderecoId: $('#enderecoId').val(),
                cep: $('#cep').val(),
                logradouro: $('#logradouro').val().trim(),
                complemento: $('#complemento').val().trim(),
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
                        text: 'Produtor gravado com sucesso!',
                        showConfirmButton: true,
                        timer: 3000
                    }).then(function () {
                        window.location.href = CTX + '/ProdutorListar';
                    });
                } else {
                    var m = MENSAGENS[codigo] ||
                            {titulo: 'Não foi possível gravar o produtor!', campo: '#nome'};
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
