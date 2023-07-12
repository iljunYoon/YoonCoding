package com.exciting.amuse.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.exciting.amuse.service.AmuseImageService;
import com.exciting.amuse.service.AmuseReviewService;
import com.exciting.amuse.service.FacilityService;
import com.exciting.amuse.service.RidesService;
import com.exciting.dto.AimageDTO;
import com.exciting.dto.AmuseReviewDTO;
import com.exciting.dto.AmusementDTO;
import com.exciting.dto.FacilityDTO;
import com.exciting.dto.RidesDTO;
import com.exciting.index.service.AmusementService;

@RestController
@RequestMapping("/test")
@CrossOrigin(origins = "http://localhost:3000")
public class TestController {
	
	@Autowired
	RidesService ridesService;
	
	@Autowired
	FacilityService facilityService;
	
	@Autowired
	AmuseImageService amuseImageService;

	@Autowired
	AmusementService amusementService;
	
	@Autowired
	AmuseReviewService amuseReviewService;
	
	@GetMapping("/amuseList")
	public List<AmusementDTO> amuseList(Map<String, Object> map){
		List<AmusementDTO> amuseList = this.amusementService.inAmusementList();
		return amuseList;
	}
	
	@GetMapping("/amuseDetail/{amuse_id}")
	public AmusementDTO amuseDetail(Map<String, Object> map,
			@PathVariable Integer amuse_id,
			HttpServletRequest request,
			HttpServletResponse response){
		
		map.put("amuse_id", amuse_id);
		float avg = this.amuseReviewService.amuseReviewGradeAvg(map);
		
		AmusementDTO dto = this.amusementService.getOneAmuseDTO(map);
		dto.setAvg_grade(avg);
		
//		//============새로고침 조회수 무한 증가 방지(쿠키 이용)============
//		// 비교를 위한 쿠키
//		Cookie viewCookie = null;
//		
//		Cookie[] cookies = request.getCookies();
//		
//		// 쿠키가 있을 경우
//		if(cookies != null && cookies.length > 0) {
//			for(int i = 0; i < cookies.length; i++) {
//				//들어온 적이 있는 경우
//				if(cookies[i].getName().equals("cookie" + dto.getAmuse_id())) {
//					viewCookie = cookies[i];
//				}
//			}
//		}
//		
//		//viewCookie 값이 없다는 건 들어온 적이 없음을 의미
//		if(viewCookie == null) {
//			System.out.println("쿠키 없음");
//			//쿠키 생성(이름, 값)
//			Cookie newCookie = new Cookie("cookie" + dto.getAmuse_id(), "|" + dto.getAmuse_id() + "|");
//			//쿠키 추가
//			response.addCookie(newCookie);
//			
//			//조회수 증가
//			this.amusementService.updateAmuseView(map);
//		}
//		//viewCookie 값이 있다는 건 들어온 적이 있음을 의미
//		else {
//			System.out.println("쿠키 있음");
//			String value = viewCookie.getValue();
//			
//			System.out.println("cookie 값 = " + value);
//		}
//		//==========================================================
		
		return dto;
	}
	
	@GetMapping("/ridesList")
	public List<RidesDTO> ridesList(Map<String, Object> map){
		map.put("amuse_id", 1);		
		List<RidesDTO> rList = this.ridesService.ridesList(map);
		return rList;
	}
	
	@GetMapping("/facilityList/{amuse_id}")
	public List<FacilityDTO> facilityList(Map<String, Object> map,
			@PathVariable Integer amuse_id){
		map.put("amuse_id", amuse_id);
		List<FacilityDTO> fList = this.facilityService.facilityListMap(map);
		return fList;
	}
	
	@GetMapping("/reviewList/{amuse_id}")
	public List<AmuseReviewDTO> reviewList(Map<String, Object> map,
			@PathVariable Integer amuse_id){
		map.put("amuse_id", amuse_id);
		List<AmuseReviewDTO> reviewList = this.amuseReviewService.amuseReviewListMap(map);
		return reviewList;
	}
	
	@GetMapping("/amuseImage/{amuse_id}")
	public List<AimageDTO> aimageList(Map<String, Object> map,
			@PathVariable Integer amuse_id){
		map.put("amuse_id", amuse_id);
		List<AimageDTO> aimageList = this.amuseImageService.aImgList(map);
		return aimageList;
	}
	
	@GetMapping("/ridesList/{amuse_id}")
	public List<RidesDTO> ridesList(Map<String, Object> map,
			@PathVariable Integer amuse_id){
		map.put("amuse_id", amuse_id);
		List<RidesDTO> ridesList = this.ridesService.ridesList(map);
		return ridesList;
	}
	
	@GetMapping("/rideDetail/{rides_id}")
	public RidesDTO rideDetail(Map<String, Object> map,
			@PathVariable Integer rides_id){
		map.put("rides_id", rides_id);
		RidesDTO rideDetail = this.ridesService.getOneRidesDTO(map);
		return rideDetail;
	}

	
	//review 작성
	@PostMapping("/write")
	public void reviewInsert(Map<String, Object> map,
			@RequestBody AmuseReviewDTO dto){
		
		//System.out.println("/////////// dto = " + dto);
		map.put("amuse_id", dto.getAmuse_id());
		map.put("member_id", dto.getMember_id());
		map.put("r_content", dto.getR_content());
		map.put("r_grade", dto.getR_grade());
		
		//review 등록
		this.amuseReviewService.insertAmuseReview(map);
		
		map.clear();
		
		int maxReviewId = this.amuseReviewService.maxReviewId(); 
		
		map.put("review_id",maxReviewId);
		
		this.amuseReviewService.updateRef(map);
	}	
	
	//답글 처리
	@PostMapping("/answer")
	public void reviewAnswer(Map<String, Object> map,
			@RequestBody AmuseReviewDTO dto){
		
		// ===== 답글 처리 =====
		int maxReviewId = this.amuseReviewService.maxReviewId(); 
		
		int ansReviewId = maxReviewId + 1;
		
		map.put("review_id", dto.getReview_id());
		AmuseReviewDTO arDTO = this.amuseReviewService.getOneAmuseReviewDTO2(map);
		
		map.put("seq", arDTO.getSeq());
		map.put("ref", arDTO.getRef());
		
		//부모글과 ref가 같은 row들의 seq가 부모글의 seq보다 크면 모두 +1
		this.amuseReviewService.updateSeq(map);
		
		map.clear();
		
		//답글 insert 하기
		//review_id, amuse_id, member_id, r_content, r_ref, r_seq, r_level
		map.put("review_id", ansReviewId);
		map.put("seq", arDTO.getSeq()+1);
		map.put("level", arDTO.getLevel()+1);
		map.put("r_content", dto.getR_content());
		map.put("amuse_id", arDTO.getAmuse_id());
		map.put("member_id", arDTO.getMember_id());
		map.put("ref", arDTO.getRef());
		
		this.amuseReviewService.insertReviewAnswer(map);
		
		System.out.println("map ===>>>>" + map);
	}
	
	//Delete
	@GetMapping("/delete/{review_id}")
	public void reviewDelete(Map<String, Object> map,
			@PathVariable Integer review_id){
		map.put("review_id", review_id);
		this.amuseReviewService.deleteReview(map);
	}
	
	//==============추천(국내)==============
	//국내 놀이공원 평점 높은 순서
	@GetMapping("/inAvgGradeList")
	public List<AmusementDTO> inAmuseListAvg(Map<String, Object> map){
		List<AmusementDTO> inAvgGradeList = this.amusementService.inAmusementListAvg();
		return inAvgGradeList;
	}
	
	//국내 놀이공원 리뷰 많은 순서
	@GetMapping("/inReviewCntList")
	public List<AmusementDTO> inAmuseListReview(Map<String, Object> map){
		List<AmusementDTO> inReviewCntList = this.amusementService.inAmusementListReview();
		return inReviewCntList;
	}
	
	//==============추천(해외)==============
	//해외 놀이공원 평점 높은 순서
	@GetMapping("/outAvgGradeList")
	public List<AmusementDTO> outAmuseListAvg(Map<String, Object> map){
		List<AmusementDTO> outAvgGradeList = this.amusementService.outAmusementListAvg();
		return outAvgGradeList;
	}
	
	//해외 놀이공원 리뷰 많은 순서
	@GetMapping("/outReviewCntList")
	public List<AmusementDTO> outAmuseListReview(Map<String, Object> map){
		List<AmusementDTO> outReviewCntList = this.amusementService.outAmusementListReview();
		return outReviewCntList;
	}
}










