package com.systematic;

import org.thymeleaf.context.ITemplateContext;
import org.thymeleaf.engine.AttributeName;
import org.thymeleaf.engine.AttributeNames;
import org.thymeleaf.model.IProcessableElementTag;
import org.thymeleaf.processor.element.IElementTagProcessor;
import org.thymeleaf.processor.element.IElementTagStructureHandler;
import org.thymeleaf.processor.element.MatchingAttributeName;
import org.thymeleaf.processor.element.MatchingElementName;
import org.thymeleaf.standard.expression.IStandardExpression;
import org.thymeleaf.standard.expression.IStandardExpressionParser;
import org.thymeleaf.standard.expression.StandardExpressions;
import org.thymeleaf.templatemode.TemplateMode;

public class FrancoAttributeProcessor implements IElementTagProcessor {

	@Override
	public MatchingElementName getMatchingElementName() {
		return null;
	}

	@Override
	public MatchingAttributeName getMatchingAttributeName() {
		AttributeName attributeName = AttributeNames.forHTMLName("systematic", "francoformat");
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

		String expressionValue = tag.getAttributeValue("systematic:francoformat");

		final IStandardExpression expression = expressionParser.parseExpression(context, expressionValue);

		final Object value = expression.execute(context);
		if (value instanceof String) {
			String formattedString = "Systematic-" + value;
			structureHandler.setBody(formattedString, false);
			structureHandler.removeAttribute("systematic:francoformat");
		}
	}
}
