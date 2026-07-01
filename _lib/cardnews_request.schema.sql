-- ===== 카드뉴스 신청 — 설치용 SQL (SQL Server) =====
-- 가비아 운영 DB(dbione)에 한 번 실행하세요.
-- 두 부분으로 나뉘어 있습니다: (1) 테이블 생성, (2) 관리자 메뉴 등록.

-- =====================================================
-- (1) 신청 데이터 테이블
-- =====================================================
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'cardnews_request')
BEGIN
    CREATE TABLE cardnews_request (
        idx               INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        company           NVARCHAR(100) NOT NULL,
        writer            NVARCHAR(50)  NOT NULL,
        phone             NVARCHAR(30)  NOT NULL,
        email             NVARCHAR(100) NULL,
        interest          NVARCHAR(200) NULL,
        note1             NVARCHAR(500) NULL,
        agree1            TINYINT       NOT NULL DEFAULT 0,
        agree2            TINYINT       NOT NULL DEFAULT 0,
        Wip               NVARCHAR(50)  NULL,
        regdate           DATETIME      NOT NULL DEFAULT GETDATE(),
        status            INT           NOT NULL DEFAULT 0,   -- 0:대기, 1:접수완료, 9:보관, 99:취소
        statusChangeDate  DATETIME      NULL,
        adMemo            NVARCHAR(MAX) NULL
    );

    CREATE INDEX IX_cardnews_request_regdate ON cardnews_request(regdate DESC);
END
GO


-- =====================================================
-- (2) 관리자 메뉴 등록
--     - menu 테이블에 카드뉴스 신청관리 메뉴 추가
--     - 관리자(admin)의 pubMenu 필드에 새 메뉴 idx 포함시켜야 메뉴가 노출됨
-- =====================================================

-- 이미 등록되어 있으면 다시 만들지 않음
-- topName='고객센터' — 기존 news/sub05(상담문의)와 같은 그룹으로 묶이도록 동일하게 설정
IF NOT EXISTS (SELECT 1 FROM menu WHERE topcode='news' AND subcode='sub06')
BEGIN
    INSERT INTO menu (topcode, subcode, topName, subName, linkurl, isUse, listnum)
    VALUES ('news', 'sub06', '고객센터', '카드뉴스 신청관리', '/backoffice/board/cardnewsList.asp', 1, 60);
END
GO

-- 신규 메뉴의 idx 확인 (실행 후 출력된 값을 사용)
SELECT idx AS newCardnewsMenuIdx
  FROM menu
 WHERE topcode='news' AND subcode='sub06';
GO

-- ★ 위 SELECT로 확인한 idx를 슈퍼관리자 admin.pubMenu 에 추가하세요.
--   pubMenu는 콤마로 구분된 메뉴 idx 목록입니다.
--   예) 기존 pubMenu = '1,2,3,5,8'  →  새 메뉴 idx가 42라면 '1,2,3,5,8,42'
--
-- 단일 슈퍼관리자만 있다면 아래 한 줄로 일괄 추가:
--
-- UPDATE admin
--    SET pubMenu = pubMenu + ','
--                + CAST((SELECT idx FROM menu WHERE topcode='news' AND subcode='sub06') AS VARCHAR(10))
--  WHERE memsort = 9;   -- (memsort=9 가 슈퍼관리자라고 가정. 실제 값은 환경에 맞게 수정)
