package com.systematic;

import org.thymeleaf.context.IExpressionContext;
import org.thymeleaf.standard.expression.IStandardConversionService;

public class FrancoConversionService implements IStandardConversionService {

	@Override
	public <T> T convert(IExpressionContext context, Object object, Class<T> targetClass) {
		if (object instanceof FrancoStudent) {
			FrancoStudent francoStudent = (FrancoStudent) object;
			String result = "FrancoStudent [studentName=" + francoStudent.getStudentName() + "]";
			return targetClass.cast(result); // Cast to the target class
		}
		return targetClass.cast(object.toString()); // Cast to the target class
	}
}
