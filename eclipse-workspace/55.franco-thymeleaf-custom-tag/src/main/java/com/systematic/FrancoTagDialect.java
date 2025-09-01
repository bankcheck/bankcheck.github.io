package com.systematic;

import java.util.HashSet;
import java.util.Set;

import org.thymeleaf.dialect.IProcessorDialect;
import org.thymeleaf.processor.IProcessor;

public class FrancoTagDialect implements IProcessorDialect {

	@Override
	public String getName() {
		return "FrancoTagDialect";
	}

	@Override
	public String getPrefix() {
		return null;
	}

	@Override
	public int getDialectProcessorPrecedence() {
		return 0;
	}

	@Override
	public Set<IProcessor> getProcessors(String dialectPrefix) {
		Set<IProcessor> processor = new HashSet<IProcessor>();
		processor.add(new FrancoTagProcessor());
		return processor;
	}
}
