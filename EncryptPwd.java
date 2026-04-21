import java.util.Base64;
import java.security.*;
import java.security.spec.*;
import javax.crypto.Cipher;
public class EncryptPwd {
  public static void main(String[] args) throws Exception {
    String pub = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC+mEDzYLbKNB9rbOuvGgwdBUpPaHryRGarxBQppkOzlj+ouep8MMq1Xg7NBkjLOV2vnn4E5AVvX0XVOmBg8W5eNQ1uS1HCG2fie8BpXGgl1pWj/HYIrA2d/U7xxvMO8UMhAGfMdaGrPrGdZTr95pzL/q+VJZOcqSAgux/YEdu11wIDAQAB";
    byte[] keyBytes = Base64.getDecoder().decode(pub);
    X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
    PublicKey key = KeyFactory.getInstance("RSA").generatePublic(spec);
    Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
    cipher.init(Cipher.ENCRYPT_MODE, key);
    byte[] enc = cipher.doFinal("123456".getBytes("UTF-8"));
    System.out.println(Base64.getEncoder().encodeToString(enc));
  }
}
