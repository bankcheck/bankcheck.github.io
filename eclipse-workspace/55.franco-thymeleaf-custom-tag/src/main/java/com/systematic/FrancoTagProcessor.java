package com.systematic;

import org.thymeleaf.context.ITemplateContext;
import org.thymeleaf.engine.AttributeName;
import org.thymeleaf.engine.AttributeNames;
import org.thymeleaf.engine.ElementName;
import org.thymeleaf.engine.ElementNames;
import org.thymeleaf.model.IProcessableElementTag;
import org.thymeleaf.processor.element.IElementTagProcessor;
import org.thymeleaf.processor.element.IElementTagStructureHandler;
import org.thymeleaf.processor.element.MatchingAttributeName;
import org.thymeleaf.processor.element.MatchingElementName;
import org.thymeleaf.standard.expression.IStandardExpression;
import org.thymeleaf.standard.expression.IStandardExpressionParser;
import org.thymeleaf.standard.expression.StandardExpressions;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.util.EvaluationUtils;

public class FrancoTagProcessor implements IElementTagProcessor {

	@Override
	public MatchingElementName getMatchingElementName() {
		ElementName elementName = ElementNames.forHTMLName("franco:if");
		MatchingElementName matchingElementName = MatchingElementName.forElementName(getTemplateMode(), elementName);
		return matchingElementName;
	}

	@Override
	public MatchingAttributeName getMatchingAttributeName() {
		AttributeName attributeName = AttributeNames.forHTMLName("", "francotest");
		MatchingAttributeName matchingAttributeName = MatchingAttributeName.forAttributeName(getTemplateMode(),
				attributeName);
		return matchingAttributeName;
	}

	@Override
	public TemplateMode getTemplateMode() {
		return TemplateMode.HTML;
	}

	@Override
	public int getPrecedence() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void process(ITemplateContext context, IProcessableElementTag tag,
			IElementTagStructureHandler structureHandler) {
		IStandardExpressionParser expressionParser = StandardExpressions
				.getExpressionParser(context.getConfiguration());

		String expressionValue = tag.getAttributeValue("francotest");

		final IStandardExpression expression = expressionParser.parseExpression(context, expressionValue);
		final Object value = expression.execute(context);

		boolean result = EvaluationUtils.evaluateAsBoolean(value);

		if (result) {
			structureHandler.removeTags();
		} else {
			structureHandler.removeElement();
		}
	}
}
