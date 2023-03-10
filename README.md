# Flutter to-do list

- [chatGPT로 플러터 앱 만들기2](https://dusunax.notion.site/chatGPT-2-300cfc1dc83e4074b2345d481e33d883)
- 2023년 2월 26일~

---

### 투두리스트 종류

- 기본적인 투두리스트
- 우선순위가 있는 투두리스트
- 마감기한이 있는 투두리스트
- 그룹별 투두리스트

### 주제별 아이디어

1. 기본

- 화분 + 식물 키우기
- 레벨, 태그, 뱃지

2. 우선 순위

- 카테고리별 우선 순위
- 다음 공부 추천

3. 마감기한

- 벌금 저금통
- 못지키면 카톡알림

4. 그룹별 투두리스트

- 단체 미션 : 오늘 커밋, 오늘 공부 등
- 단체 투두리스트 알림

### 간단함 유지하기

- 이전 작업 [chatGPT로 플러터 앱 만들기1](https://dusunax.notion.site/chatGPT-1-2b8d7646733146e5808b27329faacba8)을 중지하고 다시 시작하는 이유 중 하나가 프로젝트의 복잡도였던 만큼, 완성을 위해서 간단한 투두리스트를 만듭니다.
- 1번 아이디어의 화분 키우기로 작업합니다.

---

## 날짜별 작업내용

### 230227 진행 상황
- 할 일 쓰기, 삭제, 완료
- 다크모드 추가

![image](https://user-images.githubusercontent.com/94776135/221604167-57825482-d48d-4685-ae64-4d57bfd6ad9c.png)

### 230301 진행 상황
- 다크모드 수정 (status바 수정 필요)
- 기본 CRUD
  - 리스트는 Dismissible(드래그로 삭제)
- 애니메이션 추가

![image](https://user-images.githubusercontent.com/94776135/221907912-f0058c02-5134-42e1-ac61-b71f6874773a.png)

### 230302 진행 상황
- 각종 버그 및 UI 개선
- 수정 내용: l18n 한글, 아이콘 theme, 다크모드, 체크박스, _plantCm
- [l18n 레퍼런스](https://fronquarry.tistory.com/8)

![image](https://user-images.githubusercontent.com/94776135/222470888-a76d4597-44e8-4000-96fb-4283b2ed2b19.png)

### 230306 진행 상황
- database: sqflite 플러그인 버그 발생
- 안드로이드 에뮬과 연결이 안되는 현상 발생

### 230308 진행 상황
- 플러터 디버그 모드 사용 시작(에뮬도 작동)
- 일부 버그 수정 및 코드 정리
- Navigator.pop(context, createdTodo) => js의 popstate랑 비슷함
