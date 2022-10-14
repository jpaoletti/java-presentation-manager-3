package jpaoletti.jpm2.web.converter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import jpaoletti.jpm2.core.exception.ConfigurationException;
import jpaoletti.jpm2.core.exception.ConverterException;
import jpaoletti.jpm2.core.model.ContextualEntity;
import jpaoletti.jpm2.core.model.Field;
import jpaoletti.jpm2.util.JPMUtils;
import jpaoletti.jpm2.web.ObjectConverterData;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author jpaoletti
 */
public class WebEditCollection extends WebEditObject {

    @Autowired
    private HttpServletRequest request;

    private boolean allowDuplicates = false;
    private String reference; //set value in the collected entity

    public WebEditCollection() {
        super();
    }

    @Override
    public Object visualize(ContextualEntity contextualEntity, Field field, Object object, String instanceId) throws ConverterException, ConfigurationException {
        final Collection<Object> value = (Collection<Object>) ((object == null) ? null : getValue(object, field));
        final String res = "@page:collection-converter.jsp"
                + "?entityId=" + getEntity().getId()
                + ((getRelated() != null) ? "&related=" + getRelated() : "")
                + ((getFilter() != null) ? "&filter=" + getFilter().getId() : "")
                + "&textField=" + getTextField()
                + "&pageSize=" + getPageSize()
                + "&currentId=" + instanceId
                + "&allowDuplicates=" + isAllowDuplicates()
                + "&addable=" + isAddable()
                + "&minSearch=" + getMinSearch();
        if (value == null || value.isEmpty()) {
            request.removeAttribute("values_" + field.getId());
            return res;
        } else {
            final List<ObjectConverterData.ObjectConverterDataItem> values = new ArrayList<>();

            final StringBuilder sb = new StringBuilder();
            for (Object o : value) {
                final String id = getEntity().getDao().getId(o).toString();
                final ObjectConverterData.ObjectConverterDataItem data = ObjectConverterData.buildDataObject(getTextField(), getEntity(), null, id, o);
                values.add(data);
                sb.append(id).append(",");
            }
            request.setAttribute("values_" + field.getId(), values);
            return res + "&value=" + sb.toString().substring(0, sb.toString().length() - 1);
        }
    }

    @Override
    public Object build(ContextualEntity contextualEntity, Field field, Object object, Object newValue) throws ConverterException {
        if (newValue == null || "".equals(newValue)) {
            return null;
        } else {
            try {
                final Collection<Object> c = (Collection<Object>) getValue(object, field);
                if (StringUtils.isNotEmpty(reference)) {
                    for (Object other : c) {
                        JPMUtils.set(other, reference, null);
                        getEntity().getDao().update(other);
                    }
                }
                c.clear();
                final String[] split = newValue instanceof String ? ((String) newValue).split("[,]") : ((String[]) newValue);
                for (String s : split) {
                    final Object other = getEntity().getDao().get(s);
                    c.add(other);
                    if (StringUtils.isNotEmpty(reference)) {
                        JPMUtils.set(other, reference, object);
                        getEntity().getDao().update(other);
                    }
                }
                return c;
            } catch (Exception ex) {
                JPMUtils.getLogger().error(ex);
                return null;
            }
        }
    }

    public boolean isAllowDuplicates() {
        return allowDuplicates;
    }

    public void setAllowDuplicates(boolean allowDuplicates) {
        this.allowDuplicates = allowDuplicates;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

}
