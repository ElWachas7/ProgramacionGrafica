using TMPro;
using UnityEngine;

public class InstantiateEntity : MonoBehaviour
{
    [Header("Referencias")]
    [SerializeField] private GameObject _juli;
    [SerializeField] public TextMeshProUGUI _instantiateButton;
    [SerializeField] private Transform _transform;
    private GameObject _currentReference;

    [Header("Variables")]
    private string _instantiateText = "Instantiate a Juli";
    private string _destroyText = "Destroy a Juli";
    private bool _hasCreated = false;
    private float _destroyTime = 7f;
    private float _currentTime;

    public void Awake()
    {
        _instantiateButton.text = _instantiateText;
    }
    public void OnClick()
    {
        if (_hasCreated)
        {
            _hasCreated = false;
            _instantiateButton.text = _instantiateText;
            DestroyAJuli();
        }
        else
        {
            _hasCreated = true;
            _instantiateButton.text = _destroyText;
            InstantiateAJuli();
        }
    }
    public void InstantiateAJuli()
    {
        _currentTime = _destroyTime;
        _currentReference = Instantiate(_juli, _transform);
    }
    public void DestroyAJuli()
    {
        Destroy(_currentReference);
        _currentReference = null;
    }
    public void Update()
    {
        if (Input.GetKeyDown(KeyCode.J))
        {
            Instantiate(_juli, _transform);
        }

        if (_hasCreated)
        {
            _currentTime -= Time.deltaTime;
            if (_currentTime <= 0)
            {
                _hasCreated = false;
                _instantiateButton.text = _instantiateText;
                Destroy(_currentReference);
                _currentReference = null;
            }
        }
    }
}



