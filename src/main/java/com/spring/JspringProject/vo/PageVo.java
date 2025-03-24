package com.spring.JspringProject.vo;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PageVo {
	private int pag;
	private int pageSize;
	private int totPage;
	private int startIndexNo;
	private int curScrStartNo;
	private int blockSize;
	private int curBlock;
	private int lastBlock;
	
	private String search;
	private String searchStr;
	private String searchString;
	private String part;
}
