package com.zeus.common.aop;

import java.util.Arrays;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
@Aspect
public class ServiceLoggerAdvice {

	@Before("execution(* com.zeus.service.ItemService*.*(..)) ")
	public void beforeLog(JoinPoint jp) {
		log.info("aspect before log");
		log.info("aspect before log=" + jp.getSignature());
		log.info("aspect before log=" + Arrays.toString(jp.getArgs()));

	}

	@After("execution(* com.zeus.service.ItemService*.*(..)) ")
	public void afterLog(JoinPoint jp) {
		log.info("aspect afterLog ");
		log.info("aspect afterLog =" + jp.getSignature());
		log.info("aspect afterLog =" + Arrays.toString(jp.getArgs()));
	}

	@AfterReturning(pointcut = "execution(* com.zeus.service.ItemService*.*(..))", returning = "result")
	public void AfterReturning(JoinPoint jp, Object result) {
		log.info("AfterReturning");
		log.info("AfterReturning : " + jp.getSignature());
		log.info("AfterReturning result : " + result.toString());
	}

	@Around("execution(* com.zeus.service.ItemService*.*(..))")
	public Object aroundLog(ProceedingJoinPoint pjp) throws Throwable {
		log.info("around log sector");
		long startTime = System.currentTimeMillis();
		log.info(Arrays.toString(pjp.getArgs()));
		//여기서 비즈니스모델을 실행, 실행시간 측정: end- start
		Object result = pjp.proceed();
		long endTime = System.currentTimeMillis();
		log.info(pjp.getSignature().getName() + " : " + (endTime - startTime));
		return result;
	}

}
