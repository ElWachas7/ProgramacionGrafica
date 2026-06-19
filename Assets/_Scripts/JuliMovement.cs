using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class JuliMovement : MonoBehaviour
{
    Rigidbody rb;
    [SerializeField] private float _velocity = 1f;

    public void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }
    public void FixedUpdate()
    {
            rb.AddForce(transform.up * _velocity, ForceMode.Impulse);
    }
}
