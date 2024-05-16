@isTest
public class EventLiveStreamControllerTest {
    
    @isTest
    public static void testGetUserDetail() {
        EventLiveStreamController.getUserDetail(UserInfo.getUserId());
        EventLiveStreamController.getUserDetail(null);
    }
}