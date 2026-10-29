package fr.teopartesi.starter;

import static org.assertj.core.api.Assertions.assertThat;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.skyscreamer.jsonassert.JSONAssert;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestComponent;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.context.annotation.Import;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, useMainMethod = SpringBootTest.UseMainMethod.ALWAYS)
@Import(StarterApplicationIT.FailureController.class)
class StarterApplicationIT {

  @LocalServerPort
  private int port;

  @Test
  void shouldReturnHealthyStatusWithoutInternalDetails() throws Exception {
    HttpResponse<String> response = get("/actuator/health");

    assertThat(response.statusCode()).isEqualTo(200);
    JSONAssert.assertEquals("{\"groups\":[\"liveness\",\"readiness\"],\"status\":\"UP\"}", response.body(), true);
  }

  @Test
  void shouldReturnNotFoundForUnknownRoute() throws Exception {
    HttpResponse<String> response = get("/unknown-route");

    assertThat(response.statusCode()).isEqualTo(404);
    assertSafeError(response, 404);
  }

  @Test
  void shouldNotExposeEnvironmentEndpoint() throws Exception {
    HttpResponse<String> response = get("/actuator/env");

    assertThat(response.statusCode()).isEqualTo(404);
    assertSafeError(response, 404);
  }

  @Test
  void shouldNotExposeTechnicalFailureEvenWhenDetailsAreRequested() throws Exception {
    HttpResponse<String> response = get("/test-only/failure?trace=true&message=true&errors=true");

    assertThat(response.statusCode()).isEqualTo(500);
    assertSafeError(response, 500);
    assertThat(response.body()).doesNotContain("internal-test-failure", "IllegalStateException", "FailureController");
  }

  private void assertSafeError(HttpResponse<String> response, int status) throws Exception {
    JSONObject body = new JSONObject(response.body());
    assertThat(body.getInt("status")).isEqualTo(status);
    assertThat(body.has("trace")).isFalse();
    assertThat(body.has("exception")).isFalse();
    assertThat(body.has("message")).isFalse();
    assertThat(body.has("errors")).isFalse();
  }

  private HttpResponse<String> get(String path) throws Exception {
    HttpRequest request = HttpRequest.newBuilder()
      .uri(URI.create("http://localhost:" + port + path))
      .timeout(Duration.ofSeconds(5))
      .header("Accept", "application/json")
      .GET()
      .build();

    try (HttpClient client = HttpClient.newHttpClient()) {
      return client.send(request, HttpResponse.BodyHandlers.ofString());
    }
  }

  @TestComponent
  @RestController
  static class FailureController {

    @GetMapping("/test-only/failure")
    String fail() {
      throw new IllegalStateException("internal-test-failure");
    }
  }
}
