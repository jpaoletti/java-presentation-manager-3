<%@include file="../default-taglibs.jsp" %>
<div id="sidebar">
    <ul>
        <li id="menu-home"><a href="${cp}index"><i class="glyphicon glyphicon-home"></i> <span><spring:message code="jpm.index.home" text="Home" /></span></a></li>
        <security:authorize ifAnyGranted="ROLE_USERADMIN">
            <li id="menu-jpm-entity-user"><a href="${cp}jpm/jpm-entity-user/"><spring:message code="jpm.entity.title.jpm-entity-user" text="Users" /></a></li>
            <li id="menu-jpm-entity-group"><a href="${cp}jpm/jpm-entity-group/"><spring:message code="jpm.entity.title.jpm-entity-group" text="Groups" /></a></li>
        </security:authorize>
    </ul>
</div>