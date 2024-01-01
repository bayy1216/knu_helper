# knu_helper
## 0. [1차개발] (2023.07.15 ~ 2023.07.20)

*주요기능*
1. 각 학과별 공지사항을 리스트를 통해 확인할 수 있어요.
2. 새로 등록된 공지사항을 알림을 통해 받아보세요.
3. 저장하고 싶은 공지사항을 즐겨찾기 기능을 통해 남겨두세요.

![image](https://github.com/bayy1216/knu_helper/assets/78216059/60355250-87d8-4318-ad04-fa998ea8926d)
![image](https://github.com/bayy1216/knu_helper/assets/78216059/25cd266b-741d-4069-afe3-3dee94db4bbb)
![image](https://github.com/bayy1216/knu_helper/assets/78216059/272128c0-5f52-4a27-8c8a-bb66bfc2b894)


### Frontend
- Flutter

### Backend
- Firebase
- Python Script (Crawling to Firebase)



## 사용기술
- simple MVVM with riverpod
- firebase
- inappwebview
- drift

<br><br><br>
<hr>

## 1. [2차개발] (2023.12.01 ~ 2024.01.01)
*무엇이 달라졌나요?*
1. 백엔드 서버를 Firebase에서 SpringBoot + PostgresSQL로 변경하였습니다.
2. 백엔드 서버 API 스펙에 맞추어 모바일의 구조를 변경하기 위해 repository 패턴을 사용하여 의존성을 나누었습니다.
3. 즐겨찾기 : StreamNotifier를 사용하여 로직을 개선하였습니다.
4. 공지사항 : 검색, 사이트별 필터링 기능을 추가하였습니다.
5. 앱 사용자들의 피드백을 통해 브라우저로 열기 기능을 추가하였습니다.

## 2. 배포 링크
> Server repositroy : https://github.com/bayy1216/knu_helper_BE
> <br>
> 플레이스토어 : [KNU MATE - 공지사항 한눈에 보기](https://play.google.com/store/apps/details?id=com.reditus.knu_helper)

## 3. 프로젝트 구조
![image](https://github.com/bayy1216/knu_helper/assets/78216059/f8ab4701-9757-44a0-b00f-8033446eb892)

주요 기술 스택
<br>
`riverpod`
<br>
`go_router` `dio` `retrofit` `drift` 
<br>
`jwt` `flutter_inappwebview` `json_serializable`
```bash
.
├── all
│   ├── setting
│   │   ├── component
│   │   │   └── opensource_item.dart
│   │   ├── model
│   │   │   ├── package.dart
│   │   │   ├── package.freezed.dart
│   │   │   └── package.g.dart
│   │   └── view
│   │       ├── open_source_screen.dart
│   │       ├── privacy_screen.dart
│   │       └── setting_screen.dart
│   ├── site
│   │   ├── component
│   │   │   └── message_popup.dart
│   │   ├── provider
│   │   │   ├── site_provider.dart
│   │   │   └── user_site_provider.dart
│   │   ├── repository
│   │   │   └── user_site_repository.dart
│   │   └── view
│   │       └── select_site_screen.dart
│   └── view
│       └── all_screen.dart
├── common
│   ├── component
│   │   ├── cow_item.dart
│   │   └── pagination_list_view.dart
│   ├── const
│   │   ├── admob_id.dart
│   │   ├── color.dart
│   │   ├── data.dart
│   │   └── text_style.dart
│   ├── database
│   │   ├── drift_database.dart
│   │   └── drift_database.g.dart
│   ├── dio
│   │   ├── dio.dart
│   │   ├── dio_client.dart
│   │   └── dio_client.g.dart
│   ├── layout
│   │   └── default_layout.dart
│   ├── model
│   │   ├── base_paginate_queries.dart
│   │   ├── cursor_pagination_model.dart
│   │   ├── cursor_pagination_model.g.dart
│   │   ├── offset_pagination_model.dart
│   │   └── offset_pagination_model.g.dart
│   ├── provider
│   │   ├── go_router.dart
│   │   ├── navigation_provider.dart
│   │   └── paginating_provider.dart
│   ├── repository
│   │   ├── base_pagination_repository.dart
│   │   └── init_setting_repository.dart
│   ├── secure_storage
│   │   └── secure_storage.dart
│   ├── utils
│   │   ├── data_utils.dart
│   │   └── paination_utils.dart
│   └── view
│       └── root_tab.dart
├── favorite
│   ├── provider
│   │   └── favorite_provider.dart
│   ├── repository
│   │   └── favorite_repository.dart
│   └── view
│       └── favorite_screen.dart
├── firebase_options.dart
├── main.dart
├── notice
│   ├── components
│   │   ├── chip_item.dart
│   │   ├── notice_card.dart
│   │   └── star_icon_button.dart
│   ├── model
│   │   ├── notice_entity.dart
│   │   ├── notice_model_deprecated.dart
│   │   ├── notice_model_deprecated.g.dart
│   │   ├── request
│   │   │   ├── paginate_notice_queries.dart
│   │   │   └── paginate_notice_queries.g.dart
│   │   ├── response
│   │   │   ├── notice_model.dart
│   │   │   ├── notice_model.g.dart
│   │   │   ├── site_info_response.dart
│   │   │   ├── site_info_response.g.dart
│   │   │   ├── site_model.dart
│   │   │   └── site_model.g.dart
│   │   └── site_enum.dart
│   ├── provider
│   │   └── notice_provider.dart
│   ├── repository
│   │   └── notice_repository.dart
│   └── view
│       ├── notice_screen.dart
│       ├── notice_web_view.dart
│       └── search_notice_screen.dart
└── user
    ├── model
    │   ├── request
    │   │   ├── delete_user_subscribed_site_request.dart
    │   │   ├── delete_user_subscribed_site_request.g.dart
    │   │   ├── user_subscribed_site_request.dart
    │   │   ├── user_subscribed_site_request.g.dart
    │   │   ├── uuid_signup_request.dart
    │   │   └── uuid_signup_request.g.dart
    │   ├── response
    │   │   ├── jwt_token.dart
    │   │   ├── jwt_token.g.dart
    │   │   ├── user_subscribed_site_response.dart
    │   │   └── user_subscribed_site_response.g.dart
    │   └── user_model.dart
    ├── provider
    │   └── user_provider.dart
    ├── repository
    │   ├── auth_repository.dart
    │   └── user_repository.dart
    └── view
        ├── login_screen.dart
        └── splash_screen.dart
```
