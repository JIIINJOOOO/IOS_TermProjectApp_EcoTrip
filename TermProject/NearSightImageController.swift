//
//  NearSightImageController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/06/07.
//

import UIKit

class NearSightImageController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var firstImage1 = ""
    var firstImage2 = ""
    
    // 1페이지마다 1개 이미지를 갖는 UIImage 배열
    var pageImages: [UIImage] = []
    // UIImageView 배열로써 optional, 필요할때 로딩하므로!
    var pageViews: [UIImageView?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let url = URL(string: firstImage1 as NSString as String)
        {
            if let data = try? Data(contentsOf: url)
            {
                pageImages.append(UIImage(data: data)!)
            }
        }
        if let url2 = URL(string: firstImage2 as NSString as String)
        {
            if let data = try? Data(contentsOf: url2)
            {
                pageImages.append(UIImage(data: data)!)
            }
        }
        //1. 5개 photo로 부터 UIImage 배열 생성
//        pageImages = [UIImage(named: "photo1.png")!,
//                      UIImage(named: "photo2.png")!,
//                      UIImage(named: "photo3.png")!,
//                      UIImage(named: "photo4.png")!,
//                      UIImage(named: "photo5.png")!
//        ]
        let pageCount = pageImages.count
        
        // 2. 현재 페이지는 0으로 설정하고 페이지 개수 설정
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        //3. 페이지 개수만큼 pageView 배열 원소를 nil로 생성
        // 나중에 로딩할 때 실제 pageImages에서 가져옴
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4. 스크롤뷰 컨텐트 width = 스크롤뷰 프레임 width x pageImages 개수
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: pagesScrollViewSize.height)
        
        // 5.이미지 로딩
        loadVisiblePages()
    }
    
    func loadPage(_ page: Int) {
        if page < 0 || page >= pageImages.count {
            return // 페이지 인덱스 범위를 벗어나면 그냥 리턴!
        }
        
        if pageViews[page] != nil {
            
        } else {
            //2. pageView가 nul이면 로딩해야함
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            //3. 새로운 UIImageView 생성하고 scrolView에 추가
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            
            //4. 새로 생성한 newPageView를 배열의 nil 대신 삽입
            scrollView.addSubview(newPageView)
        }
    }
    
    // 현재 페이지 앞뒤를 제외하고 나머지는 pageView 배열에서 제거할 것임
    func purgePage(_ page: Int) {
        if page < 0 || page >= pageImages.count {
            // 페이지 인덱스 범위를 벗어나면 그냥 리턴
            return
        }
        
        //pageViews[page]가 nil이 아니라면 scrollView에서 제거하고
        //pageViews[page]는 nil로 만듦
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    // 현재페이지와 앞 뒤 페이지만 로딩하고 나머지는 메모리에서 제거 purge
    func  loadVisiblePages() {
        // 현재 페이지 번호 계산
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // pageControl 현재 페이지 갱신
        pageControl.currentPage = page
        
        // 현재 페이지 앞뒤 페이지 설정
        let firstPage = page - 1
        let lastPage = page + 1
        
        // 페이지 0..<앞페이지 전까지 제거
        for index in 0 ..< firstPage + 1 {
            purgePage(index)
        }
        
        // 앞, 현재, 뒤 3개 페이지만 로딩
        for index in firstPage ... lastPage {
            loadPage(index)
        }
        // 뒤페이지<...끝페이지까지 제거
        for index in lastPage + 1 ..< pageImages.count + 1 {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 현재 스크린에 있는 페이지 로드
        loadVisiblePages()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
