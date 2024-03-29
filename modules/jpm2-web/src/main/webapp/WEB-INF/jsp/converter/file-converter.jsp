<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="file-converter-container-${field}">
    <button type="button" class="btn btn-default btn-sm fileinput-button pull-left">
        <i class="glyphicon glyphicon-upload"></i>
        <input name="file" id="field_${field}"  type="file" data-url="${cp}jpm/uploadFileConverter" ${param.multiple?'multiple=""':''} />
    </button>
    <input name="field_${field}" type="hidden" value="@current:" />
    <div id="progress_${field}" class="progress file-converter-progress"><div class="progress-bar"></div></div>
        <c:if test="${param.delete}">
        <a class="file-converter-delete" href="javascript: ;" class="${field}_delete"><span class="glyphicon glyphicon-remove"></span> <spring:message code="jpm.converter.file.delete" text="Delete" /></a>
        <span class="file-converter-text"><spring:message code="jpm.converter.file.bytes.text" text="?" arguments="${param.len}" /></span>
    </c:if>
    <c:if test="${not param.delete}">
        <span class="file-converter-text"><spring:message code="jpm.converter.file.null.file.text" text="-" /></span>
    </c:if>
</div>
<script src="${cp}static/js/jquery.fileupload/jquery.ui.widget.js"></script>
<script src="${cp}static/js/jquery.fileupload/jquery.iframe-transport.js"></script>
<script src="${cp}static/js/jquery.fileupload/jquery.fileupload.js"></script>
<script>
    jpmLoad(function() {
        if (!$("link[href='${cp}static/css/jquery.fileupload-ui.css']").length) {
            $('<link href="${cp}static/css/jquery.fileupload-ui.css" rel="stylesheet">').appendTo("head");
        }
        $("#file-converter-container-${field} .file-converter-delete").on("click", function() {
            $("input[name='field_${field}']").val("");
            $("#file-converter-container-${field} .file-converter-text").css("text-decoration","line-through");
            $('#progress_${field} .progress-bar').css('width', '0%');
        });
        $('#field_${field}').fileupload({
            dataType: 'json',
            acceptFileTypes: ${param.accept},
        }).on('fileuploadprogressall', function(e, data) {
            $("button[type='submit']").addClass("disabled");
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress_${field} .progress-bar').css('width', progress + '%');
        }).on('fileuploaddone', function(e, data) {
            $.each(data.result.files, function(index, file) {
                $("input[name='field_${field}']").val(file.name);
            });
            $('#progress_${field} .progress-bar').addClass("progress-bar-success");
            $("button[type='submit']").removeClass("disabled");
            $("#file-converter-container-${field} .file-converter-text").css("text-decoration","line-through");
        }).on('fileuploadfail', function(e, data) {
            $.each(data.files, function(index, file) {
                alert("File upload failed");
                $("button[type='submit']").removeClass("disabled");
            });
        })
    });
</script>