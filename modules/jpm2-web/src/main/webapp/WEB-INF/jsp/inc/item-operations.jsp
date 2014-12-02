<div class="btn-group">
    <c:forEach items="${itemOperations}" var="o">
        <a class="btn btn-sm btn-default confirm-${o.confirm}" 
           href="${cp}jpm/${contextualEntity}/${instance.id}/${o.operation}">
            <i class="glyphicon jpmicon-${o.id}"></i> <spring:message code="${o.title}" text="${o.title}" arguments=" " />
        </a>
    </c:forEach>
</div>