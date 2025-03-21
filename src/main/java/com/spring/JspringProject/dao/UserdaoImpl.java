package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.JspringProject.vo.UserVo;

//이렇게 UserdaoImpl 만들어서 매퍼에서 sql 가져다가 쓰는건 sql세션템플릿방식임
//sql세션방식에선 UserdaoImpl 안만들고 Userdao랑 매퍼파일을 연결시켜서 임플없이 사용함

//@Repository("Userdao")
//@Repository //스프링 3.0부턴 ()안에 써주는거 생략가능/ 
//@Repository("Userdao")에서 ("Userdao")를 생략하면, userDaoImpl이라는 이름으로 자동 등록됨
//중요!! 그런데 sql세션템플릿에서만 임플을 만들기떄문에 원래는 생략 가능한데 
// 이 프로젝트에선 sql세션템플릿방식과 sql세션방식을 둘다쓰고있기에 생략불가능함 
// 그냥 세션방식에선 임플파일을 안만들기에 임플파일을 만들어서 리퍼지토리 어노테이션을 쓰는
// 세션템플릿방식이랑 충돌(빈이 겹침)이 나서 500번대 에러가 나오게됨

//정리하자면
//루트컨텍스트.xml에 있는 <mybatis-spring:scan base-package="com.spring.JspringProject.dao"/> 
//이건 com.spring.JspringProject.dao 패키지 내의 모든 MyBatis 인터페이스를 찾아서 빈(Bean)으로 등록하는 역할을 하는데
//다오임플에서 @Repository를 등록할때 빈이름("Userdao")을 지정하지않으면
//자동으로 userDaoImpl이 빈으로 등록되는데 이럴경우
//<mybatis-spring:scan base-package="com.spring.JspringProject.dao"/> 이걸로 유저다오도 인터페이스타입이라 자동으로 빈으로 등록되는데
//이렇게 유저다오와 유저다오임플 둘다 빈으로 등록되어버리게되어 둘다 UserDao의 인터페이스기에 스프링에서 어느쪽을 구현객체로 써야할지 몰라서 500번대 에러가 발생하게되는거임

//즉, sql세션방식과 sql세션템플릿방식 둘다 사용할경우 다오임플에서 리퍼지토리네임을 매번적어줘야함
//하지만 sql세션템플릿방식만 사용한다면 리퍼지토리 네임 생략가능

//+추가정보 및 정리
//@Repository // 이 클래스를 빈으로 등록함, 리포지포리명을 지정안하면 현재 위치 즉, userDaoImpl이 자동으로 등록됨
//@Autowired <=기존에 등록된 빈을 사용할수있게 찾아서 연결해 주는 것
//유저 서비스 임플에서 
//@Autowired Userdao userdao;로 설정하면 Userdao란 이름을 가진 빈을 찾아서 주입(연결) 시켜주는것
//@Autowired UserdaoImpl userdao;로 설정하면 UserdaoImpl란 이름을 가진 빈을 찾아서 주입(연결) 시켜주는것
//즉,다오임플에서 @Repository로 쓰고 서비스임플에서 Userdao userdao;로 설정하면 다오임플에서 빈으로 등록된건 다오임플인데
//서비스임플에서는 유저다오란 빈을 찾아서 주입하려하니 에러가 생기게되는거임 + <mybatis-spring:scan base-package="com.spring.JspringProject.dao"/>
//이걸로 인해 유저다오도 빈으로 등록되게 되어서 유저다오,유저다오임플 이렇게 두개의 빈이 등록됨 유저다오와 유저다오임플은 서로 연결되어있는 관계라 어느걸 써야하는지 스프링에서 몰라서 에러가나게됨

//그렇다면 에러가 안나게하려면? 다오임플에서 @Repository로 쓰고 서비스임플에서 @Autowired UserdaoImpl userdao;로 설정해주거나
//다오임플에서 @Repository("Userdao")로 쓰고 서비스임플에서 @Autowired Userdao userdao;로 설정하면 되고
//서로 차이점들이 겹처서 에러가난 부분이니까(sql세션방식은 다오만 씀, sql세션템플릿방식은 다오임플을 씀)
//아예 프로젝트작업중에 다오임플을 안만들고 작업하는 sql세션 방식 하나만 사용하면 되거나
//아니면 다오임플은 안만드는 sql세션방식을 쓰지않고 다오임플을 꼭만들어줘야하는 sql세션템플릿방식 하나만 사용하면됨
//


@Repository
public class UserdaoImpl implements Userdao {
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public UserVo getUserIdSearch(String mid) {
		String sql = "select * from user where mid = ?";
		//매퍼의 네임스페이스명.매퍼에 만들어놓은 sql문의 id명,매개값
		//가져다 쓸 매퍼에 만들어놓은 sql의 id명을 맘대로 정해도 되지만 
		//헷갈리니까 가능하면 매퍼에 매핑한 sql의 id명을 impl에서 가져다 쓰는 함수명이랑 맞춰주는게 좋음
		//추가정보
		//+ sql세션템플릿방식에선 매퍼에 매핑한 id명이 같은이름(중복가능)이 여러개 올수있지만(오버로딩가능)
		//+ sql세션방식(sql세션템플릿방식의 업그레이드버전)에선 매퍼에 매핑한 id명을 같은이름을 쓸수없기에 sql세션환경도 고려해야함
		//그렇기에 같은이름을 쓰는게 불가능한 impl에 있는 메서드명과 
		//매퍼에 매핑한 id명을 같은이름을 써주는거임
		return sqlSession.selectOne("userNS.getUserIdSearch", mid);
	}

	@Override
	public int setUserInput(UserVo vo) {
		return sqlSession.insert("userNS.setUserInput", vo);
	}

	@Override
	public UserVo getUserSearchPart(UserVo vo) {
		return sqlSession.selectOne("userNS.getUserSearchPart", vo);
	}

	@Override
	public List<UserVo> getUserList() {
		
		return sqlSession.selectList("userNS.getUserList");
	}

	@Override
	public int setUserDeleteOk(int idx) {
		return sqlSession.delete("userNS.setUserDeleteOk", idx);
	}

	@Override
	public UserVo getSearchIdx(int idx) {
		return sqlSession.selectOne("userNS.getSearchIdx", idx);
	}

	@Override
	public int getUserUpdate(UserVo vo) {
		return sqlSession.update("userNS.getUserUpdate", vo);
	}
	
	

}
