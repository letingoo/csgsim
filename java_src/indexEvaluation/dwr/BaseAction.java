/**
 * BaseAction.java
 */
package indexEvaluation.dwr;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.ActionServlet;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.struts.DispatchActionSupport;

//import com.metarnet.common.model.Constants;
//import com.metarnet.security.model.User;
//import com.nms.util.Util;

/**
 * @description ��IWorkFlowFactoryע��BaseAction���������DAO,�Լ���ת�����ķ���
 * @author zhhuang
 * @date 2007-10-12
 */
public class BaseAction extends DispatchActionSupport implements ApplicationContextAware
{
	public static Log logger = LogFactory.getLog(BaseAction.class);

	public static final String DIRECTLY_MESSAGE_KEY = "message";

	public static final String DIRECTLY_ERROR_KEY = "error";

//	private static IWorkFlowFactory workFlowFactory = null;

	private static ApplicationContext applicationContext;

//	public void setServlet(ActionServlet actionServlet)
//	{
//		super.setServlet(actionServlet);
//		if (actionServlet != null)
//		{
//			ServletContext servletContext = actionServlet.getServletContext();
//			if (workFlowFactory == null)
//			{
//				WebApplicationContext wac = WebApplicationContextUtils
//						.getRequiredWebApplicationContext(servletContext);
//				workFlowFactory = (WorkFlowFactory) wac.getBean("workflowFacade");
//			}
//		}
//	}

	/**
	 * ��ȡ����ʵ�� ���workFlowFactory==null����˵������struts��ʹ��
	 * 
	 * @return the workFlowFactory
	 */
//	public static IWorkFlowFactory getWorkFlowFactory()
//	{
//		if (workFlowFactory == null)
//			workFlowFactory = (WorkFlowFactory) getBean("workflowFacade");
//		return workFlowFactory;
//	}

	public static Object getBean(String beanName)
	{
		return applicationContext.getBean(beanName);
	}

	/**
	 * ����ȷ��scope�б���FormBean�����.
	 */
	protected void updateFormBean(ActionMapping mapping, HttpServletRequest request, ActionForm form)
	{
		if (mapping.getAttribute() != null)
		{
			if ("request".equals(mapping.getScope()))
			{
				request.setAttribute(mapping.getAttribute(), form);
			} else
			{
				HttpSession session = request.getSession();
				session.setAttribute(mapping.getAttribute(), form);
			}
		}
	}

	/**
	 * ����ȷ��scope�����FormBean.
	 */
	protected void removeFormBean(ActionMapping mapping, HttpServletRequest request)
	{
		if (mapping.getAttribute() != null)
		{
			if ("request".equals(mapping.getScope()))
			{
				request.removeAttribute(mapping.getAttribute());
			} else
			{
				HttpSession session = request.getSession();
				session.removeAttribute(mapping.getAttribute());
			}
		}
	}

	public void setApplicationContext(ApplicationContext arg0) throws BeansException
	{
		applicationContext = arg0;

	}

	/**
	 * ���̼򵥵��ύ����
	 * 
	 * @param id
	 *            �?ID
	 * @param stepId
	 *            ��ǰ�?��״̬ID
	 * @param request��HttpServletRequest
	 * @return ���̲��������ֵ�ҳ��Url
	 */
//	public static String flowAction(String id, String stepId, HttpServletRequest request)
//	{
//		return flowAction(id, stepId, null, true, false, request);
//	}

	/**
	 * ���̿缶���ύ����
	 * 
	 * @param id
	 *            �?ID
	 * @param stepId
	 *            ��ǰ�?��״̬ID
	 * @param isJump
	 *            �Ƿ�缶
	 * @param request
	 *            HttpServletRequest
	 * @return ���̲��������ֵ�ҳ��Url
	 */
//	public static String flowAction(String id, String stepId, boolean isJump, HttpServletRequest request)
//	{
//		return flowAction(id, stepId, null, true, isJump, request);
//	}

	/**
	 * ������˲���
	 * 
	 * @param id
	 *            �?ID
	 * @param stepId
	 *            ��ǰ�?��״̬ID
	 * @param content
	 *            �������
	 * @param isPassed
	 *            ��ʶ��ͨ���ǳ���
	 * @param request��HttpServletRequest
	 * @return ���̲��������ֵ�ҳ��Url
	 */
//	public static String flowAction(String id, String stepId, String content, boolean isPassed,
//			HttpServletRequest request)
//	{
//		return flowAction(id, stepId, content, isPassed, false, request);
//	}

	/**
	 * �缶��������˲���
	 * 
	 * @param id
	 *            �?ID
	 * @param stepId
	 *            ��ǰ�?��״̬ID
	 * @param content
	 *            �������
	 * @param isPassed
	 *            ��ʶ��ͨ���ǳ���
	 * @param isJump
	 *            �Ƿ�缶
	 * @param request
	 *            HttpServletRequest
	 * @return ���̲��������ֵ�ҳ��Url
	 */
//	public static String flowAction(String id, String stepId, String content, boolean isPassed, boolean isJump,
//			HttpServletRequest request)
//	{
//		String result = null, nextStep = null;
//		User user = (User) request.getSession().getAttribute(Constants.SESSION_USER_KEY);
//		Step step = getWorkFlowFactory().getStep(stepId);
//		if (step == null)
//		{
//			logger.info("���̶�������ʧ�ܣ������ڵĲ���" + stepId);
//			return null;
//		}
//		OperateHistory history = new OperateHistory();
//		history.setId(id);
//		history.setHistStepId(step.getId());		
//		history.setOperator(user.getUserName());
//		history.setContent(content);
//		history.setFlowTypeId(step.getFlowTypeID());
//		if (step.isCheck())
//		{
//			if (isPassed)
//			{
//				result = "���ͨ��";
//				if (isJump && !Util.isNull(step.getJumpForward()))
//					nextStep = step.getJumpForward();
//				else
//					nextStep = step.getForward();
//			} else
//			{
//				result = "����";
//				if (isJump && !Util.isNull(step.getJumpBackward()))
//					nextStep = step.getJumpBackward();
//				else
//					nextStep = step.getBackward();
//			}
//		} else
//		{
//			result = null;
//			if (isJump && !Util.isNull(step.getJumpForward()))
//				nextStep = step.getJumpForward();
//			else {
//				nextStep = step.getForward();
//			}
//		}
//		history.setResult(result);
//		history.setStepId(nextStep);
//		getWorkFlowFactory().updateStatus(history);
//		return getWorkFlowFactory().getFlowType(step.getId()).getHomeUrl();
//	}	

	/**
	 * �󶨵�����
	 * 
	 * @param form
	 * @param object
	 */
	protected void bindEntity(ActionForm form, Object object)
	{
		if (form != null)
		{
			try
			{
				BeanUtils.copyProperties(object, form);
			} catch (Exception e)
			{
				logger.info("Bind to object error" + e.getMessage());
			}
		}
	}

	/**
	 * �󶨵��?
	 * 
	 * @param form
	 * @param object
	 */
	protected void bindForm(ActionForm form, Object object)
	{
		if (form != null)
		{
			try
			{
				BeanUtils.copyProperties(form, object);
			} catch (Exception e)
			{
				logger.info("Bind to form error" + e.getMessage());
			}
		}
	}

	/**
	 * ֱ�ӱ����ı���Ϣ(��i18n)errors.
	 * 
	 * @param request
	 * @param message
	 *            ֱ�ӵĴ����ı���Ϣ
	 */
	protected void saveDirectlyError(HttpServletRequest request, String message)
	{
		ActionErrors errors = new ActionErrors();
		errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(DIRECTLY_MESSAGE_KEY, message));
		saveErrors(request, errors);
		request.setAttribute(DIRECTLY_ERROR_KEY, message);
	}

	/**
	 * ֱ�ӱ����ı���Ϣ(��i18n)msgs.
	 * 
	 * @param request
	 * @param message
	 *            ֱ�ӵ���ʾ�ı���Ϣ
	 */
	protected void saveDirectlyMessage(HttpServletRequest request, String message)
	{
		ActionMessages msgs = new ActionMessages();
		msgs.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(DIRECTLY_MESSAGE_KEY, message));
		saveMessages(request, msgs);
		request.setAttribute(DIRECTLY_MESSAGE_KEY, message);
	}
}
