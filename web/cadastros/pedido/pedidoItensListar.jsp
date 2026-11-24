<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="pt_BR"/>
<jsp:include page="/header.jsp"/>
<jsp:include page="/menu.jsp"/>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Itens do Pedido</h1>
    <p class="mb-4">Pedido nº ${pedidoId}</p>

    <a class="btn btn-secondary mb-4" href="${pageContext.request.contextPath}/PedidoListar">
        <i class="fas fa-undo-alt"></i>
        <strong>Voltar</strong>
    </a>

    <div class="card shadow mb-4">
        <div class="card-body">
            <c:choose>
                <c:when test="${empty itens}">
                    <p class="mb-0">Este pedido não possui itens</p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <c:set var="totalPedido" value="0"/>
                        <table class="table table-bordered table-dark" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>Produto</th>
                                    <th class="text-center">Quantidade</th>
                                    <th class="text-center">Preço unitário</th>
                                    <th class="text-right">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${itens}">
                                    <c:set var="totalPedido" value="${totalPedido + item.subtotal}"/>
                                    <tr>
                                        <td><c:out value="${item.produtoNome}"/></td>
                                        <td class="text-center">${item.quantidade}</td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${item.precoUnitario}" type="currency"/>
                                        </td>
                                        <td class="text-right">
                                            <fmt:formatNumber value="${item.subtotal}" type="currency"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="3" class="text-right">Total</th>
                                    <th class="text-right">
                                        <fmt:formatNumber value="${totalPedido}" type="currency"/>
                                    </th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="/footer.jsp"/>